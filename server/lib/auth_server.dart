import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as sio;
import 'package:shelf_router/shelf_router.dart';

import 'config/constants.dart';
import 'middleware/logger.dart';
import 'model/json_response.dart';

part 'auth_server.g.dart';

abstract class AccessToken {
  // String sign();
  // => jwt.sign(
  //   SecretKey(_secretKey, isBase64Encoded: true),
  //   algorithm: JWTAlgorithm.HS256,
  // );
}

/// [RFC 9068](https://www.rfc-editor.org/info/rfc9068/) defines required claims
/// — iss, exp, aud, sub, client_id, iat, jti — and a standard scope claim.
/// See https://oauth.net/2/jwt-access-tokens/.
@JsonSerializable()
final class JWTAccessToken implements AccessToken {
  const JWTAccessToken({
    required this.audience,
    required this.clientID,
    required this.issuedAt,
    required this.issuer,
    required this.jwtID,
    required this.expirationTime,
    required this.scope,
    required this.sub,
  });

  @JsonKey(name: 'aud')
  final String audience;

  @JsonKey(name: 'client_id')
  final String clientID;

  factory JWTAccessToken.fromJson(Map<String, Object?> json) =>
      _$JWTAccessTokenFromJson(json);

  /// The UNIX timestamp for the datetime at which this token was issued.
  @JsonKey(name: 'iat')
  final int issuedAt;

  @JsonKey(name: 'iss')
  final String issuer;

  @JsonKey(name: 'jti')
  final String jwtID;

  /// The UNIX timestamp for the datetime at which this token will expire.
  @JsonKey(name: 'exp')
  final int expirationTime;

  @JsonKey(name: 'scope')
  final String scope;

  @JsonKey(name: 'sub')
  final String sub;

  Map<String, Object?> toJson() => _$JWTAccessTokenToJson(this);
}

/// Builds [JSON Web Tokens (JWTs)](https://www.jwt.io/).
class _JWTBuilder {
  JWTWithExpiry build(String clientID, String host, int port) {
    final JWTAlgorithm algorithm = JWTAlgorithm.HS256;

    final claims = tokenClaims(host, port);
    final issuedAt = DateTime.now().toUtc().millisecondsSinceEpoch;
    final accessToken = JWTAccessToken(
      audience: claims['aud'] as String,
      clientID: clientID,
      issuedAt: issuedAt,
      issuer: claims['iss'] as String,
      jwtID: DateTime.now().toIso8601String(),
      expirationTime: issuedAt + validDuration,
      scope: AuthServer._recognisedClients[clientID]!['scope'],
      sub: clientID,
    );

    // TODO check typ value is correct against RFC JWT/JWS specs
    final headerMap = {"alg": algorithm.name, "typ": "JWT"};

    final jwt = JWT(accessToken.toJson(), issuer: issuer, header: headerMap);

    return JWTWithExpiry(
      jwt: jwt,
      expiryDuration: accessToken.expirationTime - accessToken.issuedAt,
    );
  }

  static Map<String, Object?> tokenClaims(String host, int port) => {
    'aud': '$host:$port',
    'iss': issuer,
  };

  static final String issuer = 'https://github.com/weasdown/dispatch/server';

  /// The amount of time the access token will be valid for, in seconds.
  final int validDuration = 600;
}

class JWTWithExpiry {
  const JWTWithExpiry({required this.jwt, required this.expiryDuration});

  final int expiryDuration;
  final JWT jwt;
}

final class AuthServer {
  /// Builds a [JSON Web Signature (JWS)](https://www.rfc-editor.org/info/rfc7515/)
  /// that contains a [JSON Web Token (JWT)](https://www.jwt.io/). The JWT
  /// authorises the client to perform particular operations on the main dispatch server.
  JsonResponse _buildBearerToken(String clientID, String host, int port) {
    final jwtWithExpiry = _JWTBuilder().build(clientID, host, port);

    final jwt = jwtWithExpiry.jwt;
    final signedJWT = _signJWT(jwt);

    final accessTokenResponse = AccessTokenResponse(
      accessToken: 'Bearer $signedJWT',
      expiresIn: jwtWithExpiry.expiryDuration,
      tokenType: 'Bearer',
    );

    return JsonResponse.ok(accessTokenResponse);
  }

  final String host = 'localhost';

  late final Logger log = Logger(runtimeType.toString());

  FutureOr<Response> _notFoundHandler(Request request) =>
      JsonResponse.notFound('Endpoint ${request.url.path} not found');

  late final int port;

  // TODO store these in a database instead, and not in plaintext.
  static final Map<String, Map<String, dynamic>> _recognisedClients = {
    'client_id': {"secretID": "client_secret", "scope": "all"},
    'admin': {"secretID": "admin", "scope": "all"},
    'ed1': {"secretID": "ed1Secret", "scope": "all"},
    'eda1': {"secretID": "eda1Secret", "scope": "all"},
    'ect1': {"secretID": "ect1Secret", "scope": "all"},
  };

  final String rootPath = '/oauth2';

  Router get router {
    final router = Router(notFoundHandler: _notFoundHandler);

    /// Get authorization.
    router.get('$rootPath/authorization', (Request request) {
      log.info('In /authorization endpoint');
      return JsonResponse.notImplemented(
        'Authorization endpoint is not yet implemented.',
      );
    });

    /// Get a bearer token.
    router.get('$rootPath/token', (Request request) {
      log.info('In /token endpoint');
      final queryParams = request.url.queryParameters;

      final validatedCredentials = _validateQueryParameters(queryParams);
      return validatedCredentials.jsonResponse ??
          _buildBearerToken(validatedCredentials.clientID!, rootPath, port);
    });

    return router;
  }

  static final String _secretKey =
      'ZGlzcGF0Y2gtYXV0aC1zZXJ2ZXItc2VjcmV0LWtleQ==';

  Future<void> serve() async {
    // Use any available host or container IP (usually `0.0.0.0`).
    final ip = InternetAddress.anyIPv4;

    final handler = Pipeline()
        .addMiddleware(logRequests(logger: logger(log)))
        .addHandler(router.call);

    // For running in containers, we respect the PORT environment variable.
    log.info('Starting auth server...');
    final port = int.parse(Platform.environment['AUTH_PORT'] ?? '8081');
    this.port = port;

    log.finer('Using port $port for auth server');
    final server = await sio.serve(handler, ip, port);
    log.info(
      'Auth server listening ${ip == InternetAddress.anyIPv4 ? 'for any IPv4 address ' : ''}on port ${server.port}',
    );
  }

  /// Cryptographically signs a JSON Web Token.
  ///
  /// Produces a string of the base64-encoded, signed value, e.g.
  /// `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjbGllbnRfaWQiLCJhZG1pbiI6dHJ1ZSwiaWF0IjoxNzk0OTAzMjY4LCJpc3MiOiJodHRwczovL2dpdGh1Yi5jb20vd2Vhc2Rvd24vZGlzcGF0Y2gvc2VydmVyIn0.DE8TJ4494LhfIvN-YUglgZO-j_rchso2lTicNDXHGfw`.
  String _signJWT(JWT jwt) => jwt.sign(
    SecretKey(_secretKey, isBase64Encoded: true),
    algorithm: JWTAlgorithm.HS256,
  );

  String get tokenEndpoint => '/token';

  ValidatedClientCredentials _validateQueryParameters(
    Map<String, String> queryParams,
  ) {
    // Must have grant_type query parameter.
    final grantTypeValue = queryParams['grant_type'];
    if (grantTypeValue == null || grantTypeValue.isEmpty) {
      return ValidatedClientCredentials(
        jsonResponse: JsonResponse.badRequest(
          'Query parameters must contain grant_type.',
        ),
      );
    }
    // grant_type must be one of the supported values.
    if (!_SupportedGrantType.isSupported(grantTypeValue)) {
      return ValidatedClientCredentials(
        jsonResponse: JsonResponse.notImplemented(
          'Grant type $grantTypeValue is not yet implemented. Must be one of: '
          '${_SupportedGrantType._names}',
        ),
      );
    }

    // Must have a client_id query parameter.
    final clientIDValue = queryParams['client_id'];
    final clientSecretValue = queryParams['client_secret'];
    if (clientIDValue == null || clientIDValue.isEmpty) {
      return ValidatedClientCredentials(
        jsonResponse: JsonResponse.badRequest(
          'Query parameters must contain client_id.',
        ),
      );
    }

    // Must have a client_secret query parameter.
    if (clientSecretValue == null || clientSecretValue.isEmpty) {
      return ValidatedClientCredentials(
        jsonResponse: JsonResponse.badRequest(
          'Query parameters must contain client_secret.',
        ),
      );
    }

    // client_id must be recognised.
    final recognisedClientSecret =
        _recognisedClients[clientIDValue]!['secretID'];
    if (recognisedClientSecret == null) {
      return ValidatedClientCredentials(
        jsonResponse: JsonResponse.unauthorized(
          'client_id "$clientIDValue" is not recognised.',
        ),
      );
    }

    // client_secret must match the recognised value for the  client_id.
    if (recognisedClientSecret != clientSecretValue) {
      return ValidatedClientCredentials(
        jsonResponse: JsonResponse.unauthorized(
          'client_secret "$clientSecretValue" is invalid for client_id "$clientIDValue".',
        ),
      );
    }

    return ValidatedClientCredentials(
      clientID: clientIDValue,
      clientSecret: clientSecretValue,
    );
  }
}

enum _SupportedGrantType {
  clientCredentials('client_credentials');

  _SupportedGrantType(this.name);

  static bool isSupported(String grantType) => _names.contains(grantType);

  final String name;

  static List<String> get _names => values
      .map((_SupportedGrantType supportedType) => supportedType.name)
      .toList();
}

// Copied from https://github.com/jonasroussel/dart_jsonwebtoken/blob/main/example/example.dart
void main() {
  // print('----- HMAC SHA-256 ------');
  // hs256();
  // print('-------------------------\n');

  print('----- RSA SHA-256 -----');
  rs256();
  print('-----------------------\n');

  // print('----- ECDSA P-256 -----');
  // es256();
  // print('-----------------------\n');
  //
  // print('----- ECDSA secp256k -----');
  // es256k();
  // print('--------------------------\n');
  //
  // print('----- RSA-PSS SHA-256 -----');
  // ps256();
  // print('---------------------------\n');
  //
  // print('----- RSA Certificate -----');
  // rsaCert();
  // print('---------------------------\n');
  //
  // print('----- EdDSA -----');
  // eddsa();
  // print('-----------------\n');
}

// // HMAC SHA-256 algorithm
// void hs256() {
//   String token;
//
//   /* Sign */
//   {
//     // Create a json web token
//     final jwt = JWT({
//       'id': 123,
//       'server': {'id': '3e4fc296', 'loc': 'euw-2'},
//     }, issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken');
//
//     // Sign it
//     token = jwt.sign(SecretKey('secret passphrase'));
//
//     print('Signed token: $token\n');
//   }
//
//   /* Verify */
//   {
//     try {
//       // Verify a token
//       final jwt = JWT.verify(token, SecretKey('secret passphrase'));
//
//       print('Payload: ${jwt.payload}');
//     } on JWTExpiredException {
//       print('jwt expired');
//     } on JWTException catch (ex) {
//       print(ex.message); // ex: invalid signature
//     }
//   }
// }

// RSA SHA-256 algorithm
void rs256() {
  String token;

  /* Sign */
  {
    // Create a json web token
    final jwt = JWT({
      'id': 123,
      'server': {'id': '3e4fc296', 'loc': 'euw-2'},
    }, issuer: _JWTBuilder.issuer);

    print('cwd: ${Directory.current}');

    // Sign it
    final pem = File('${Constants.credentialsPath}/server.csr')
        .readAsStringSync();
    final key = RSAPrivateKey(pem);

    token = jwt.sign(key, algorithm: JWTAlgorithm.RS256);

    print('Signed token: $token\n');
  }

  /* Verify */
  {
    try {
      // Verify a token
      final pem = File('${Constants.credentialsPath}/server.key')
          .readAsStringSync();
      final key = RSAPublicKey(pem);

      final jwt = JWT.verify(token, key);

      print('Payload: ${jwt.payload}');
    } on JWTExpiredException {
      print('jwt expired');
    } on JWTException catch (ex) {
      print(ex.message); // ex: invalid signature
    }
  }
}

// // ECDSA P-256 algorithm
// void es256() {
//   String token;
//
//   /* Sign */
//   {
//     // Create a json web token
//     final jwt = JWT({
//       'id': 123,
//       'server': {'id': '3e4fc296', 'loc': 'euw-2'},
//     }, issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken');
//
//     // Sign it
//     final pem = File('./example/ec_private.pem').readAsStringSync();
//     final key = ECPrivateKey(pem);
//
//     token = jwt.sign(key, algorithm: JWTAlgorithm.ES256);
//
//     print('Signed token: $token\n');
//   }
//
//   /* Verify */
//   {
//     try {
//       // Verify a token
//       final pem = File('./example/ec_public.pem').readAsStringSync();
//       final key = ECPublicKey(pem);
//
//       final jwt = JWT.verify(token, key);
//
//       print('Payload: ${jwt.payload}');
//     } on JWTExpiredException {
//       print('jwt expired');
//     } on JWTException catch (ex) {
//       print(ex.message); // ex: invalid signature
//     }
//   }
// }
//
// // ECDSA secp256k algorithm
// void es256k() {
//   String token;
//
//   /* Sign */
//   {
//     // Create a json web token
//     final jwt = JWT({
//       'id': 123,
//       'server': {'id': '3e4fc296', 'loc': 'euw-2'},
//     }, issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken');
//
//     // Sign it
//     final pem = File('./example/ec_256k_private.pem').readAsStringSync();
//     final key = ECPrivateKey(pem);
//
//     token = jwt.sign(key, algorithm: JWTAlgorithm.ES256K);
//
//     print('Signed token: $token\n');
//   }
//
//   /* Verify */
//   {
//     try {
//       // Verify a token
//       final pem = File('./example/ec_256k_public.pem').readAsStringSync();
//       final key = ECPublicKey(pem);
//
//       final jwt = JWT.verify(token, key);
//
//       print('Payload: ${jwt.payload}');
//     } on JWTExpiredException {
//       print('jwt expired');
//     } on JWTException catch (ex) {
//       print(ex.message); // ex: invalid signature
//     }
//   }
// }
//
// // RSA-PSS SHA-256 algorithm
// void ps256() {
//   String token;
//
//   /* Sign */
//   {
//     // Create a json web token
//     final jwt = JWT({
//       'id': 123,
//       'server': {'id': '3e4fc296', 'loc': 'euw-2'},
//     }, issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken');
//
//     // Sign it
//     final pem = File('./example/rsa_pss_private.pem').readAsStringSync();
//     final key = RSAPrivateKey(pem);
//
//     token = jwt.sign(key, algorithm: JWTAlgorithm.PS256);
//
//     print('Signed token: $token\n');
//   }
//
//   /* Verify */
//   {
//     try {
//       // Verify a token
//       final pem = File('./example/rsa_pss_public.pem').readAsStringSync();
//       final key = RSAPublicKey(pem);
//
//       final jwt = JWT.verify(token, key);
//
//       print('Payload: ${jwt.payload}');
//     } on JWTExpiredException {
//       print('jwt expired');
//     } on JWTException catch (ex) {
//       print(ex.message); // ex: invalid signature
//     }
//   }
// }
//
// // RSA Certificate
// void rsaCert() {
//   String token;
//
//   /* Sign */
//   {
//     // Create a json web token
//     final jwt = JWT({
//       'id': 123,
//       'server': {'id': '3e4fc296', 'loc': 'euw-2'},
//     }, issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken');
//
//     // Sign it
//     final pem = File('./example/rsa_cert_private.pem').readAsStringSync();
//     final key = RSAPrivateKey(pem);
//
//     token = jwt.sign(key, algorithm: JWTAlgorithm.RS256);
//
//     print('Signed token: $token\n');
//   }
//
//   /* Verify */
//   {
//     try {
//       // Verify a token
//       final pem = File('./example/rsa_certificate.pem').readAsStringSync();
//       final key = RSAPublicKey.cert(pem);
//
//       final jwt = JWT.verify(token, key);
//
//       print('Payload: ${jwt.payload}');
//     } on JWTExpiredException {
//       print('jwt expired');
//     } on JWTException catch (ex) {
//       print(ex.message); // ex: invalid signature
//     }
//   }
// }
//
// void eddsa() {
//   String token;
//
//   /* Sign */
//   {
//     // Create a json web token
//     final jwt = JWT({
//       'id': 123,
//       'server': {'id': '3e4fc296', 'loc': 'euw-2'},
//     }, issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken');
//
//     // Sign it
//     final privPem = File('./example/eddsa_private.pem').readAsStringSync();
//     final key = EdDSAPrivateKey.fromPEM(privPem);
//
//     token = jwt.sign(key, algorithm: JWTAlgorithm.EdDSA);
//
//     print('Signed token: $token\n');
//   }
//
//   /* Verify */
//   {
//     try {
//       // Verify a token
//       final pem = File('./example/eddsa_public.pem').readAsStringSync();
//       final key = EdDSAPublicKey.fromPEM(pem);
//
//       final jwt = JWT.verify(token, key);
//
//       print('Payload: ${jwt.payload}');
//     } on JWTExpiredException {
//       print('jwt expired');
//     } on JWTException catch (ex) {
//       print(ex.message); // ex: invalid signature
//     }
//   }
// }

extension StringBase64Encode on String {
  // String encodeAsBase64() => base64.encode(utf8.encode(this));

  String encodeAsBase64URL() => base64Url.encode(utf8.encode(this));
}

extension MapBase64Encode on Map<String, Object?> {
  // String encodeAsBase64() => json.encode(this).encodeAsBase64();

  String encodeAsBase64URL() => json.encode(this).encodeAsBase64URL();
}

class ValidatedClientCredentials {
  ValidatedClientCredentials({
    this.clientID,
    this.clientSecret,
    this.jsonResponse,
  });

  final String? clientID;
  final String? clientSecret;

  final JsonResponse? jsonResponse;
}

/// See https://www.oauth.com/oauth2-servers/access-tokens/access-token-response/.
@JsonSerializable(includeIfNull: false)
final class AccessTokenResponse {
  const AccessTokenResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    this.refreshToken,
    this.scope,
  });

  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'expires_in')
  final int expiresIn;

  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  @JsonKey(name: 'scope')
  final String? scope;

  // TODO convert to enum
  @JsonKey(name: 'token_type')
  final String tokenType;

  factory AccessTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AccessTokenResponseToJson(this);
}

/// See https://www.oauth.com/oauth2-servers/access-tokens/access-token-response/#:~:text=Unsuccessful%20Response.
@JsonSerializable()
final class AuthErrorResponse {
  AuthErrorResponse({
    this.statusCode = HttpStatus.badRequest,
    required this.error,
    this.errorDescription,
    this.errorUri,
  });

  final ErrorParameter error;

  @JsonKey(name: 'error_description')
  final String? errorDescription;

  @JsonKey(name: 'error_uri')
  final String? errorUri;

  @JsonKey(name: 'status_code')
  final int statusCode;

  factory AuthErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthErrorResponseFromJson(json);

  Map<String, Object?> toJson() => _$AuthErrorResponseToJson(this);
}

/// For use in an [AuthErrorResponse].
enum ErrorParameter {
  invalidRequest,
  invalidClient,
  invalidGrant,
  invalidScope,
  unauthorizedClient,
  unsupportedGrantType;

  factory ErrorParameter.fromJson(String value) => switch (value) {
    'invalid_request' => invalidRequest,
    'invalid_client' => invalidClient,
    'invalid_grant' => invalidGrant,
    'invalid_scope' => invalidScope,
    'unauthorized_client' => unauthorizedClient,
    'unsupported_grant_type' => unsupportedGrantType,
    _ => throw ArgumentError.value(
      value,
      'value',
      'invalid error parameter value. Must be one of: ${ErrorParameter.values}',
    ),
  };

  String toJson() => switch (this) {
    ErrorParameter.invalidRequest => 'invalid_request',
    ErrorParameter.invalidClient => 'invalid_client',
    ErrorParameter.invalidGrant => 'invalid_grant',
    ErrorParameter.invalidScope => 'invalid_scope',
    ErrorParameter.unauthorizedClient => 'unauthorized_client',
    ErrorParameter.unsupportedGrantType => 'unsupported_grant_type',
  };
}

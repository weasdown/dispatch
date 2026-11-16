import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as sio;
import 'package:shelf_router/shelf_router.dart';

import 'config/constants.dart';
import 'middleware/logger.dart';
import 'model/json_response.dart';

/// Builds [JSON Web Tokens (JWTs)](https://www.jwt.io/).
class _JWTBuilder {
  String _build(String clientID) {
    final JWTAlgorithm algorithm = JWTAlgorithm.HS256;

    // TODO check typ value is correct against RFC JWT/JWS specs
    final headerMap = {"alg": algorithm.name, "typ": "JWT"};

    // FIXME set appropriate payload keys/values
    final payloadMap = {"sub": clientID, "admin": true};

    final jwt = JWT(payloadMap, issuer: issuer, header: headerMap);

    final signedJWT = _signJWT(jwt);
    return signedJWT;
  }

  String call(String clientID) => _build(clientID);

  static final String issuer = 'https://github.com/weasdown/dispatch/server';

  static final String _secretKey =
      'ZGlzcGF0Y2gtYXV0aC1zZXJ2ZXItc2VjcmV0LWtleQ==';

  /// Cryptographically signs a JSON Web Token.
  String _signJWT(JWT jwt) => jwt.sign(
    SecretKey(_secretKey, isBase64Encoded: true),
    algorithm: JWTAlgorithm.HS256,
  );
}

final class AuthServer {
  /// Builds a [JSON Web Signature (JWS)](https://www.rfc-editor.org/info/rfc7515/)
  /// that contains a [JSON Web Token (JWT)](https://www.jwt.io/). The JWT
  /// authorises the client to perform particular operations on the main dispatch server.
  JsonResponse _buildBearerToken(String clientID) {
    final jwt = _buildJWT(clientID);

    return JsonResponse.ok(jwt);
  }

  String _buildJWT(String clientID) => _jwtBuilder(clientID);

  final _JWTBuilder _jwtBuilder = _JWTBuilder();

  late final Logger log = Logger(runtimeType.toString());

  FutureOr<Response> _notFoundHandler(Request request) =>
      JsonResponse.notFound('Endpoint ${request.url.path} not found');

  // TODO store these in a database instead, and not in plaintext.
  Map<String, String> get _recognisedClients => {
    'client_id': 'client_secret',
    'admin': 'admin',
    'ed1': 'ed1Secret',
    'eda1': 'eda1Secret',
    'ect1': 'ect1Secret',
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
          _buildBearerToken(validatedCredentials.clientID!);
    });

    return router;
  }

  Future<void> serve() async {
    // Use any available host or container IP (usually `0.0.0.0`).
    final ip = InternetAddress.anyIPv4;

    final handler = Pipeline()
        .addMiddleware(logRequests(logger: logger(log)))
        .addHandler(router.call);

    // For running in containers, we respect the PORT environment variable.
    log.info('Starting auth server...');
    final port = int.parse(Platform.environment['AUTH_PORT'] ?? '8081');
    log.finer('Using port $port for auth server');
    final server = await sio.serve(handler, ip, port);
    log.info(
      'Auth server listening ${ip == InternetAddress.anyIPv4 ? 'for any IPv4 address ' : ''}on port ${server.port}',
    );
  }

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
    final recognisedClientSecret = _recognisedClients[clientIDValue];
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

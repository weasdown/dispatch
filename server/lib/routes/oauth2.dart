import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../config/constants.dart';
import '../model/json_response.dart';
import 'api.dart';

class OAuth2Api extends Api {
  JsonResponse _buildBearerToken() {
    return JsonResponse.notImplemented(
      'Bearer token endpoint is not yet implemented.',
    );
  }

  static final String issuer = 'https://github.com/weasdown/dispatch/server';

  // TODO store these in a database instead, and not in plaintext.
  Map<String, String> get _recognisedClients => {
    'client_id': 'client_secret',
    'admin': 'admin',
    'ed1': 'ed1Secret',
    'eda1': 'eda1Secret',
    'ect1': 'ect1Secret',
  };

  @override
  Router get router {
    final router = Router();

    /// Get authorization.
    router.get('/authorization', (Request request) {
      return JsonResponse.notImplemented(
        'Authorization endpoint is not yet implemented.',
      );
    });

    /// Get a bearer token.
    router.get('/token', (Request request) {
      final queryParams = request.url.queryParameters;

      return _validateQueryParameters(queryParams) ?? _buildBearerToken();
    });

    return router;
  }

  String get tokenEndpoint => '/token';

  JsonResponse? _validateQueryParameters(Map<String, String> queryParams) {
    // Must have grant_type query parameter.
    final grantTypeValue = queryParams['grant_type'];
    if (grantTypeValue == null || grantTypeValue.isEmpty) {
      return JsonResponse.badRequest(
        'Query parameters must contain grant_type.',
      );
    }
    // grant_type must be one of the supported values.
    if (!_SupportedGrantType.isSupported(grantTypeValue)) {
      return JsonResponse.notImplemented(
        'Grant type $grantTypeValue is not yet implemented. Must be one of: '
        '${_SupportedGrantType._names}',
      );
    }

    // Must have a client_id query parameter.
    final clientIDValue = queryParams['client_id'];
    final clientSecretValue = queryParams['client_secret'];
    if (clientIDValue == null || clientIDValue.isEmpty) {
      return JsonResponse.badRequest(
        'Query parameters must contain client_id.',
      );
    }

    // Must have a client_secret query parameter.
    if (clientSecretValue == null || clientSecretValue.isEmpty) {
      return JsonResponse.badRequest(
        'Query parameters must contain client_secret.',
      );
    }

    // client_id must be recognised.
    final recognisedClientSecret = _recognisedClients[clientIDValue];
    if (recognisedClientSecret == null) {
      return JsonResponse.unauthorized(
        'client_id "$clientIDValue" is not recognised.',
      );
    }

    // client_secret must match the recognised value for the  client_id.
    if (recognisedClientSecret != clientSecretValue) {
      return JsonResponse.unauthorized(
        'client_secret "$clientSecretValue" is invalid for client_id "$clientIDValue".',
      );
    }

    return null;
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
    }, issuer: OAuth2Api.issuer);

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

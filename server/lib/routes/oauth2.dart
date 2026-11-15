import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

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

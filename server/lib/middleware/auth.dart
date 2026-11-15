import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';

import '../config/constants.dart';

// TODO implement OAuth2 authentication using oauth2 package (https://pub.dev/packages/oauth2)
/// Implements a simple auth Middleware.
///
/// This is provided as an example for Flutter architectural purposes only
/// and shouldn't be used as example on how to implement authentication
/// in production.
///
/// This Middleware checks if the token is present in the request headers,
/// otherwise returns a 401 Unauthorized response.
///
/// This token does not expire and is not secure.
Middleware authRequests() =>
    (innerHandler) => (Request request) async {
      final log = Logger('authRequests');
      final authHeader = request.headers['Authorization'];
      final expectedHeader = 'Bearer ${Constants.token}';
      if ((request.url.path != 'login') && (authHeader != expectedHeader)) {
        log.warning('Unauthorized request received');
        // If the request is not a login request and the token is not present,
        // return a 401 Unauthorized response.
        return Response.unauthorized('Unauthorized');
      }

      log.info('Request authorized');
      return innerHandler(request);
    };

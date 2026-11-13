import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../config/constants.dart';
import '../model/login/login.dart';
import 'api.dart';

class LoginApi implements Api {
  @override
  Logger get log => Logger('LoginApi');

  @override
  Router get router {
    final router = Router();

    router.post('/', (Request request) async {
      log.info('In login / POST endpoint');

      final body = await request.readAsString();
      if (body.isEmpty) {
        return Response.badRequest(
          body: 'Request body with credentials must be provided',
          headers: Constants.contentTypeJSON,
        );
      }
      final loginRequest = LoginRequest.fromJson(json.decode(body));

      if (loginRequest.email == Constants.email &&
          loginRequest.password == Constants.password) {
        return Response.ok(
          json.encode(
            LoginResponse(token: Constants.token, esr: Constants.esr),
          ),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response.unauthorized('Invalid credentials');
    });

    return router;
  }
}

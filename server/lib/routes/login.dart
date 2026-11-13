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
      final body = await request.readAsString();
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

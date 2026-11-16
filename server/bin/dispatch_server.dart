// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:dispatch_server/middleware/auth.dart';
import 'package:dispatch_server/routes/event.dart';
import 'package:dispatch_server/routes/login.dart';
import 'package:dispatch_server/routes/oauth2.dart';
import 'package:dispatch_server/routes/unit.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()
  ..mount('/oauth2', OAuth2Api().router.call)
  ..mount('/event', EventApi().router.call)
  ..mount('/unit', UnitApi().router.call)
  ..mount('/login', LoginApi().router.call);

void main(List<String> args) async {
  final log = getLogger('root');

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(logRequests(logger: logger(log)))
      .addMiddleware(authRequests())
      .addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  log.info('Starting server...');
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  log.info('Server listening on port ${server.port}');
}

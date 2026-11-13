// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

// import 'package:dispatch_server/middleware/auth.dart';
// import 'package:dispatch_server/routes/event.dart';
import 'package:dispatch_server/routes/login.dart';
import 'package:dispatch_server/web_socket_server.dart';
import 'package:logging/logging.dart';
// import 'package:dispatch_server/routes/unit.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()
  // ..mount('/event', EventApi().router.call)
  // ..mount('/unit', UnitApi().router.call)
  // // TODO add other routes
  ..mount('/login', LoginApi().router.call);

void main(List<String> args) async {
  hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.ALL; // TODO set this to a lower level
  Logger.root.onRecord.listen((record) {
    print('[${record.loggerName}] [${record.level}] ${record.message}');
  });
  final log = Logger.root;

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(logRequests())
      // // TODO add authRequests middleware
      // .addMiddleware(authRequests())
      .addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  log.info('Server listening on port ${server.port}');

  WebSocketServer.run();
  log.info('WebSocketServer started');
}

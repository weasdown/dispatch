// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:dispatch_server/middleware/auth.dart';
import 'package:dispatch_server/routes/event.dart';
import 'package:dispatch_server/routes/login.dart';
import 'package:dispatch_server/routes/oauth2.dart';
import 'package:dispatch_server/routes/unit.dart';
import 'package:logging/logging.dart';
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
  hierarchicalLoggingEnabled = true;
  final log = Logger.root
    // TODO set this to a lower level
    ..level = Level.ALL
    ..onRecord.listen((record) {
      final loggerName = record.loggerName.isEmpty ? 'root' : record.loggerName;
      print('${record.time} [$loggerName] [${record.level}] ${record.message}');
    });

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  void logger(String message, bool isError) => isError
      ? log.severe('Operation failed with error', message)
      : log.fine(message);

  log.info('Building pipeline');
  final handler = Pipeline()
      .addMiddleware(logRequests(logger: logger))
      .addMiddleware(authRequests())
      .addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  log.info('Starting server...');
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  log.info('Server listening on port ${server.port}');
}

import 'package:logging/logging.dart';
import 'package:shelf_router/shelf_router.dart';

abstract interface class Api {
  Logger get log;

  Router get router;
}

import 'package:logging/logging.dart';
import 'package:shelf_router/shelf_router.dart';

abstract class Api {
  Logger get log => Logger(runtimeType.toString());

  Router get router;
}

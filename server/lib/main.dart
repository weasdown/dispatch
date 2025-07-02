import 'package:dispatch/data/services/local_data_service.dart';
import 'package:server/server.dart';

void main() {
  // WebSocketServer.run();

  // TODO switch back to WebSocketServer
  HttpDispatchServer.run(localDataService: LocalDataService());
}

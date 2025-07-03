import 'package:dispatch/data/services/local_data_service.dart';
import 'package:server/server.dart';

void main() {
  HttpDispatchServer.run(localDataService: LocalDataService());
}

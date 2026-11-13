import 'package:dispatch_server/web_socket_server.dart';

void main() {
  final server = WebSocketServer.run();
  print(server);
}

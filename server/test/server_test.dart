import 'package:dispatch_server/server.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      final server = WebSocketServer.run();
      print(server);
    });
  });
}

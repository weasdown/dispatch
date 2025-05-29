import 'package:shelf/shelf.dart';

abstract class Api {
  Future<Response> handler(Request request);
}

import 'package:dispatch/domain/models/event/event.dart';
import 'package:server/apis/endpoint.dart';

import 'api.dart';

/// Implements a simple events API.
final class EventsApi extends Api {
  final List<Event> _events = [];

  @override
  // TODO: implement endpoints
  List<Endpoint> get endpoints => throw UnimplementedError();
}

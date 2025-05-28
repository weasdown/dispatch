import 'dart:async';
// import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../../domain/models/event/event.dart';
import '../../../../../utils/result.dart';
// import '../../repositories/event/event_repository.dart';

class ApiClient {
  ApiClient({String? host, int? port})
    : _host = host ?? 'localhost',
      _port = port ?? 8080;

  WebSocketChannel? _channel;

  WebSocketChannel? get channel => _channel;

  Uri get _channelUri => Uri(scheme: 'ws', host: _host, port: _port);

  Future<WebSocketChannel> connect() async {
    final channel = WebSocketChannel.connect(_channelUri);
    _channel = channel;

    await channel.ready;

    return channel;
  }

  // Future<Result<List<Event>>> events({
  //   required EventUpdateCallback onUpdate,
  //   required List<Event> Function() eventsCallback,
  // }) async {
  //   /// Converts stream String data to `List<Event>`.
  //   void onEventData(String data) {
  //     // updateClientEvents(List<Event> latestEvents) =>
  //     //     newEvents = latestEvents;
  //     // print('- ApiClient got new data (${data.runtimeType}): $data');
  //
  //     Map<String, dynamic> dataJson = json.decode(data);
  //
  //     print('\ndataJson keys: ${dataJson.keys}');
  //
  //     List<Map<String, dynamic>> eventJsons = dataJson['events']
  //         .cast<Map<String, dynamic>>();
  //
  //     // print('eventJsons (${eventJsons.runtimeType}): $eventJsons');
  //
  //     List<Event> newEvents = [];
  //     for (Map<String, dynamic> eventJson in eventJsons) {
  //       newEvents.add(Event.fromJson(eventJson));
  //     }
  //     print('newEvents: $newEvents');
  //
  //     onUpdate(newEvents);
  //
  //     print(
  //       '\n- _events (as callback) in listen() (${eventsCallback().runtimeType}): ${eventsCallback()}',
  //     );
  //
  //     onUpdate(eventsCallback());
  //
  //     // updateClientEvents();
  //
  //     // Provider.of<EventRepositoryRemote>(context, listen: false).events =
  //     //     retrievedEvents;
  //     // context.read<EventRepositoryRemote>().events = retrievedEvents;
  //   }
  //
  //   await _nullCheckChannel();
  //   // channel!.stream.cast<String>().asBroadcastStream();
  //   // print('stream is a broadcast stream? ${channel!.stream.isBroadcast}');
  //
  //   print('\nIn ApiClient.events');
  //   // TODO remove commented code throughout getter
  //   // List<Event> retrievedEvents = [];
  //
  //   try {
  //     // HTTP access, copied from compass_app - TODO remove example code
  //     /*final request = await client.get(_host, _port, '/booking');
  //     await _authHeader(request.headers);
  //     final response = await request.close();
  //     if (response.statusCode == 200) {
  //       final stringData = await response.transform(utf8.decoder).join();
  //       final json = jsonDecode(stringData) as List<dynamic>;
  //       final bookings = json
  //           .map((element) => BookingApiModel.fromJson(element))
  //           .toList();
  //       return Result.ok(bookings);
  //     } else {
  //       return const Result.error(HttpException("Invalid response"));
  //     }*/
  //
  //     requestEvents;
  //
  //     // FIXME: change below to not listen to stream - already listened to in WebSocketServer._coreHandler.
  //     // await for (final List<Event> apiEvents in channel!.stream) {
  //     //   retrievedEvents.addAll(apiEvents);
  //     // }
  //
  //     // String response = await channel!.stream.cast<String>().listen(
  //     //   (String data) {},
  //     // );
  //     // .asFuture<String>();
  //
  //     // // FIXME: if channel.stream line below is uncommented, "Unhandled Exception: Bad state: Stream has already been listened to.".
  //     channel!.stream.cast<String>().listen(onEventData);
  //
  //     List<Event> updatedEvents = eventsCallback();
  //     print('updatedEvents: $updatedEvents');
  //     // return Result.ok(updatedEvents);
  //     Result<List<Event>> result = Result.ok(eventsCallback());
  //     print('result in ApiClient.events(): $result');
  //     return result;
  //
  //     // onUpdate(eventsCallback());
  //
  //     // return StreamBuilder<List<Event>>(stream: stream, builder: builder);
  //
  //     // channel!.transform();
  //
  //     // List<Event> events = await channel!.stream.cast<List<Event>>().last;
  //     // print(
  //     //   '\t- _events (as callback): ${eventsCallback(newEvents)} (${eventsCallback(newEvents).runtimeType})',
  //     // );
  //
  //     // channel!.stream.cast<List<Event>>().listen(
  //     //   (List<Event> events) => retrievedEvents = events,
  //     // );
  //   } on Exception catch (error) {
  //     return Result.error(error);
  //   }
  //   // finally {
  //   //   client.close();
  //   // }
  //
  //   // await requestEvents;
  //   // return Result.ok(null);
  //
  //   // print('events in ApiClient.events: $events');
  //   // return Future(() => Result.ok(events));
  //   // // return channel.stream.cast<Map<String, dynamic>>().listen((
  //   // //     Map<String, dynamic> json,
  //   // //     ) {
  //   // //   switch (json) {
  //   // //     case {'events': List<Event> events, 'units': List<Unit> units}:
  //   // //       ;
  //   // //     case _:
  //   // //       throw const FormatException('Failed to load album.');
  //   // //   }
  //   // //   ;
  //   // //
  //   // //   // channel.sink.add('received!');
  //   // //   // channel.sink.close(status.goingAway);
  //   // // });
  // }

  final String _host;

  String get host => _host;

  Future<void> _nullCheckChannel() async {
    if (channel == null) {
      _channel = await connect();
    }
  }

  final int _port;

  int get port => _port;

  // Stream<Object> get stream {
  //   if (channel == null) {
  //     connect();
  //   }
  //
  //   return channel!.stream.cast<Object>(); //.asBroadcastStream();
  // }

  // Future<void> get requestEvents async {
  //   await _nullCheckChannel();
  //   channel!.sink.add('events');
  // }

  Future<Result<List<Event>>> get requestEvents async {
    await _nullCheckChannel();

    List<Event> newEvents = [];

    Result<List<Event>> result = Result.error(
      WebSocketChannelException('Could not get event data'),
    );

    try {
      channel!.stream.cast<String>().listen((String data) {
        channel!.sink.add('events');

        print('Received data: $data');
        result = Result.ok(newEvents);
      });
    } on Exception catch (e) {
      print('\n!! Caught exception $e');
      return Result.error(e);
    }

    return result;
  }

  Future<void> get requestUnits async {
    await _nullCheckChannel();
    channel!.sink.add('units');
  }
}

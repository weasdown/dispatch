import 'package:flutter/material.dart';

import 'logic/event.dart';
import 'presentation/event_table.dart';
// import 'logic/unit.dart';
// import 'map.dart';

void main() async {
  List<Event> defaultEvents = [];
  for (Future<Event> futureEvent in futureDefaultEvents) {
    defaultEvents.add(await futureEvent);
  }

  runApp(NewCAD(events: EventListModel(events: defaultEvents)));
}

class NewCAD extends StatelessWidget {
  NewCAD({super.key, EventListModel? events})
    : eventModel = events ?? EventListModel.blank();

  final EventListModel eventModel;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'New CAD',
      // TODO to create Theme, see https://docs.flutter.dev/cookbook/design/themes#create-an-app-theme
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue[700]!),
      ),
      // home: MapPage(events: eventModel.events, units: defaultUnits),
      home: Scaffold(
        appBar: AppBar(title: Text('EventTable')),
        body: Center(child: EventTable(events: eventModel.events)),
      ),
    );
  }
}

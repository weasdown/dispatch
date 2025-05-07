import 'package:flutter/material.dart';

import '../logic/event.dart';

/// A table displaying a list of [Event]s.
class EventTable extends StatelessWidget {
  const EventTable({super.key, required this.events});

  final List<Event> events;

  /// Returns a [TableRow] to display a given [event].
  TableRow eventRow(Event event) => TableRow(children: [Text('Wow!')]);

  static List<String> get headings => ['ID', 'Time', 'P'];

  static TableRow get headingsRow => TableRow(
    children: List<Widget>.from(
      headings.map((String heading) => Text(heading)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    print('In EventTable, events: $events');
    return Table(
      children: <TableRow>[
        headingsRow,
        // ...List<TableRow>.from(events.map((Event event) => eventRow(event))),
      ],
    );
  }
}

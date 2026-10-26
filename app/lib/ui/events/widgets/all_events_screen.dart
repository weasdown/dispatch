import 'package:gap/gap.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../ui/events/priority_colour.dart';
import '../../../ui/unit/unit_status_colour.dart';
import '../view_models/all_events_view_model.dart';

class AllEventsScreen extends StatefulWidget {
  const AllEventsScreen({super.key, required this.viewModel});

  // TODO consider merging AllEventsVewModel with SingleEventScreenViewModel and renaming to EventsViewModel or similar.
  final AllEventsVewModel viewModel;

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
  final Map<int, _EventTableField> columnOrdering = {
    // TODO define column ordering here so it can be referred to across DataRows, DataColumns and _EventTableFields
  };

  List<Event> _events = [];

  late final _AllEventTableFields _fields = _AllEventTableFields(
    onSort: onSort,
  );

  Logger get _log {
    final Logger log = Logger('_AllEventsScreenState');
    log.level = Level.ALL;
    return log;
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      sortAscending = !sortAscending;
    });
    onSortColum(_events, columnIndex, ascending);
  }

  void onSortColum(List<Event> events, int columnIndex, bool ascending) {
    // TODO add logic for sorting other columns. Pull fields to sort from _fields, e.g. _fields[columnIndex].field.
    return switch (columnIndex) {
      0 =>
        (ascending)
            ? events.sort((a, b) => a.id.compareTo(b.id))
            : events.sort((a, b) => b.id.compareTo(a.id)),
      1 =>
        (ascending)
            ? events.sort((a, b) => a.status.compareTo(b.status))
            : events.sort((a, b) => b.status.compareTo(a.status)),

      int _ => throw ArgumentError.value(
        columnIndex,
        'columnIndex',
        'column is not sortable',
      ),
    };
  }

  WidgetStateProperty<Color> rowColour(Event event) =>
      WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        // // TODO implement yellow colour for unviewed event. Will require viewedBy attribute on Event and matching ones on EventRepository and AllEventsViewModel.
        // if (event.notViewed) {
        //   return Colors.yellow[300];
        // }
        // else {
        return event.status.priority.backgroundColour;
        // }

        // // TODO if selected, apply a grey colour on top of the base colour
        // if (states.contains(WidgetState.selected)) {
        //   return Colors.grey[400]!;
        // }
      });

  bool sortAscending = true;
  int sortColumnIndex = 1;

  // TODO other attributes and move into _EventRow
  List<DataCell> tableRow(Event event, BuildContext context) => [
    // ID
    _fields.idField.cellBuilder(event),

    // TODO implement items in tableRow() for event time. Will need to implement timer on Event.
    // // Time
    // DataCell(Text('Time')),

    // Status
    _fields.statusField.cellBuilder(event),

    // Assigned units
    _fields.assignedUnitsField.cellBuilder(event),

    // Notes
    _fields.notesField.cellBuilder(event),

    // Location
    _fields.locationField.cellBuilder(event),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Events',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel.loadEvents,
        builder: (context, _) {
          return ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, child) {
              debugPrint('Number of events: ${widget.viewModel.events.length}');

              if (widget.viewModel.loadEvents.completed) {
                // // TODO implement event sorting e.g. by Time, Priority, Status or just Priority Status.
                // viewModel.events.sort();

                _events = widget.viewModel.events;

                return child!;
              } else {
                widget.viewModel.loadEvents.execute();
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Loading events...',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Gap(32),
                    SizedBox(width: 32, child: CircularProgressIndicator()),
                  ],
                ),
              );
            },
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  child: SingleChildScrollView(
                    child: DataTable(
                      sortAscending: sortAscending,
                      sortColumnIndex: sortColumnIndex,
                      // TODO make columns resizeable
                      columns: _fields.fields
                          .map((_EventTableField field) => field.header)
                          .toList(),
                      rows: widget.viewModel.events
                          .map(
                            (Event event) => DataRow(
                              onLongPress: () {
                                _log.fine(
                                  'Event ${event.idLastFour} long pressed',
                                );
                                // TODO implement app-wide selecting of event (to show it on SingleEventScreen)
                              },
                              cells: tableRow(event, context),
                              color: rowColour(event),
                            ),
                          )
                          .toList(),
                      // FIXME fix height to automatically grow if multiple units assigned. Should use a GridView so units use maximum width available.
                      // dataRowMaxHeight: 400, // For dynamic row content height.
                      dividerThickness: 1,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

final class _AllEventTableFields {
  const _AllEventTableFields({required this.onSort});

  _EventTableField get assignedUnitsField => _EventTableField(
    heading: 'Units',
    cellBuilder: (Event event) => DataCell(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double mainAxisSpacing = 8.0;
            final double crossAxisSpacing = 8.0;
            final double boxWidth = 94;
            final double boxHeight = 32;

            return GridView.count(
              crossAxisCount: (constraints.maxWidth / boxWidth).toInt(),
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
              shrinkWrap: true,
              mainAxisExtent: boxHeight,
              children: List<Widget>.from(
                event.assignedUnits.map(
                  (Unit unit) => SizedBox(
                    height: boxHeight,
                    width: boxWidth,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: BoxBorder.all(color: Colors.black),
                        color: unit.status.backgroundColour,
                      ),
                      child: Center(
                        child: Text(
                          unit.callsign,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: unit.status.textColour),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
    columnWidth: FixedColumnWidth(150),
  );

  _EventTableField get idField => _EventTableField(
    heading: 'ID',
    cellBuilder: (Event event) => DataCell(Text(event.idLastFour.toString())),
    onSort: onSort,
  );

  // TODO add other fields
  List<_EventTableField> get fields => [
    idField,
    // priorityField,
    statusField,
    assignedUnitsField,
    notesField,
    locationField,
  ];

  _EventTableField get locationField => _EventTableField(
    heading: 'Location',
    cellBuilder: (Event event) => DataCell(
      Text(event.address?.toString() ?? event.location?.toString() ?? ''),
    ),
    columnWidth: FractionColumnWidth(0.6),
  );

  _EventTableField get notesField => _EventTableField(
    heading: 'Notes',
    cellBuilder: (Event event) => DataCell(
      Text(
        // TODO implement getting of Notes from event. Will need new Event.notes attribute and getter.
        'NOTES PLACEHOLDER',
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    columnWidth: IntrinsicColumnWidth(),
  );

  final void Function(int columnIndex, bool ascending) onSort;

  _EventTableField get priorityField => _EventTableField(
    heading: 'Priority',
    cellBuilder: (Event event) => DataCell(Text(event.priority.toString())),
  );

  _EventTableField get statusField => _EventTableField(
    heading: 'Status',
    cellBuilder: (Event event) =>
        DataCell(Text(event.category?.toString() ?? event.status.toString())),
    onSort: onSort,
  );

  List<DataCell> tableRows(Event event, BuildContext context) =>
      fields.map((_EventTableField field) => field.cellBuilder(event)).toList();

  // TODO implement time field
  _EventTableField get timeField =>
      throw UnimplementedError('Time field is not yet implemented.');
}

final class _EventTableField {
  _EventTableField({
    required this.heading,
    required this.cellBuilder,
    this.onSort,
    this.columnWidth,
  });

  final DataCell Function(Event event) cellBuilder;
  final TableColumnWidth? columnWidth;
  final String heading;
  final void Function(int columnIndex, bool ascending)? onSort;

  DataColumn get header => DataColumn(
    label: Text(heading),
    headingRowAlignment: MainAxisAlignment.start,
    onSort: onSort,
    columnWidth: columnWidth,
  );
}

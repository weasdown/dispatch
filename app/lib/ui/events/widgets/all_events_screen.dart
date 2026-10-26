import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../ui/events/priority_colour.dart';
import '../../../ui/unit/unit_status_colour.dart';
import '../view_models/all_events_view_model.dart';

class AllEventsScreen extends StatelessWidget {
  const AllEventsScreen({super.key, required this.viewModel});

  // TODO consider merging AllEventsVewModel with SingleEventScreenViewModel and renaming to EventsViewModel or similar.
  final AllEventsVewModel viewModel;

  // TODO other attributes and move into _EventRow
  List<DataCell> tableRow(Event event, BuildContext context) => [
    // ID
    DataCell(Text(event.id.toString())),
    // Status
    DataCell(Text(event.category?.toString() ?? event.status.toString())),
    // Assigned units
    DataCell(
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
    // Location
    DataCell(
      Text(event.address?.toString() ?? event.location?.toString() ?? ''),
    ),
  ];

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
        listenable: viewModel.loadEvents,
        builder: (context, _) {
          return ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) {
              debugPrint('Number of events: ${viewModel.events.length}');

              if (viewModel.loadEvents.completed) {
                // // TODO implement event sorting e.g. by Time, Priority, Status or just Priority Status.
                // viewModel.events.sort();
                return child!;
              } else {
                viewModel.loadEvents.execute();
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
                      // TODO make columns resizeable
                      columns: [
                        // ID
                        DataColumn(
                          label: Text('ID'),
                          headingRowAlignment: MainAxisAlignment.start,
                          // columnWidth: FractionColumnWidth(0.2),
                        ),
                        // Status
                        DataColumn(
                          label: Text('Status'),
                          headingRowAlignment: MainAxisAlignment.start,
                          // columnWidth: FractionColumnWidth(0.2),
                        ),
                        // Assigned units
                        DataColumn(
                          label: Text('Units'),
                          headingRowAlignment: MainAxisAlignment.start,
                          columnWidth: FixedColumnWidth(
                            150,
                          ), //FractionColumnWidth(0.2),
                        ),
                        // Location
                        DataColumn(
                          label: Text('Location'),
                          headingRowAlignment: MainAxisAlignment.start,
                          columnWidth: FractionColumnWidth(0.6),
                        ),
                      ],
                      rows: viewModel.events
                          .map(
                            (Event event) => DataRow(
                              cells: tableRow(event, context),
                              color: rowColour(event),
                            ),
                          )
                          .toList(),
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

class _EventRow extends StatelessWidget {
  const _EventRow({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

enum SortDirection { ascending, descending, none }

import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../../domain/models/unit/unit.dart';
import '../../../domain/models/unit/unit_status.dart';
import '../../../ui/unit/unit_status_colour.dart';
import '../../../utils/result.dart';
import '../view_models/units_view_model.dart';

class AllUnitsScreen extends StatefulWidget {
  const AllUnitsScreen({super.key, required this.viewModel});

  // TODO consider merging AllEventsVewModel with SingleEventScreenViewModel and renaming to EventsViewModel or similar.
  final UnitsViewModel viewModel;

  @override
  State<AllUnitsScreen> createState() => _AllUnitsScreenState();
}

class _AllUnitsScreenState extends State<AllUnitsScreen> {
  late Timer timer;
  // late String timeInStatus;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Create a timer that runs a callback every 200 milliseconds to update UI
    timer = Timer.periodic(const Duration(milliseconds: 200), (Timer timer) {
      setState(() {
        // timeInStatus = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Units')),
      body: SingleChildScrollView(
        // TODO wrap with Center
        child: ListenableBuilder(
          listenable: Listenable.merge([
            widget.viewModel.loadUnits,
            // widget.viewModel.timer,
          ]),
          builder: (context, child) {
            // If command is running, show progress indicator
            if (widget.viewModel.loadUnits.running) {
              return const Center(child: CircularProgressIndicator());
            }

            // If existing booking fails to load, tap to go /home
            if (widget.viewModel.loadUnits.error) {
              return Center(
                child: ErrorWidget.withDetails(
                  message: 'Error while loading units',
                  error: FlutterError(
                    (widget.viewModel.loadUnits.result as Error<List<Unit>>)
                        .error
                        .toString(),
                  ),
                ),
              );
            }
            return child!;
          },
          child: DataTable(
            columns: <DataColumn>[
              // Callsign
              DataColumn(label: Text('Callsign')),
              // Type (vehicle type)
              DataColumn(label: Text('Type')),
              // // TODO implement display of number of personnel on vehicle
              // DataColumn(label: Text('# P')),
              // MBW
              DataColumn(label: Text('MBW')),
              // EOS
              DataColumn(label: Text('EOS')),
              // Status
              DataColumn(label: Text('Status')),
              // Time (in status)
              DataColumn(label: Text('Time')),
              // Assigned event
              DataColumn(label: Text('Assigned event')),
              // Location
              DataColumn(label: Text('Location')),
            ],
            rows:
                widget.viewModel.units?.map((Unit unit) {
                  final UnitStatus status = unit.status;
                  final Color statusTextColour = status.textColour;
                  Text textColouredByStatus(String text) =>
                      Text(text, style: TextStyle(color: statusTextColour));

                  final WidgetStateProperty<Color> backgroundColour =
                      WidgetStateProperty.resolveWith<Color>((
                        Set<WidgetState> states,
                      ) {
                        return status.backgroundColour;

                        // // TODO if selected, apply a grey colour on top of the base colour
                        // if (states.contains(WidgetState.selected)) {
                        //   return Colors.grey[400]!;
                        // }
                      });

                  return DataRow(
                    color: backgroundColour,
                    cells: [
                      // Callsign
                      DataCell(textColouredByStatus(unit.callsign)),
                      // Vehicle type
                      DataCell(
                        textColouredByStatus(unit.vehicleType.abbreviation),
                      ),
                      // MBW
                      DataCell(
                        textColouredByStatus(
                          unit.mealBreakWindow != null
                              ? unit.mealBreakWindow.toString()
                              : '',
                        ),
                      ),
                      // EOS
                      DataCell(
                        textColouredByStatus(
                          unit.endOfShift != null
                              ? unit.endOfShift!.toHM()
                              : '',
                        ),
                      ),
                      // Status
                      DataCell(textColouredByStatus(unit.status.abbreviation)),
                      // Time in status
                      DataCell(textColouredByStatus(unit.timeInStatus.toHMS())),
                      // Assigned event
                      DataCell(
                        textColouredByStatus(
                          (unit.assignedEvent != null)
                              ? unit.assignedEvent!.id.toString()
                              : '',
                        ),
                      ),
                      // Location
                      // TODO display address at unit's current location (e.g. full address if at scene, or just road name if mobile)
                      DataCell(
                        textColouredByStatus(unit.location.toSimpleString()),
                      ),
                    ],
                  );
                }).toList() ??
                [],
          ),
        ),
      ),
    );
  }
}

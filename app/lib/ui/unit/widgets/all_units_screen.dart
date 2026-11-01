import 'dart:async';

import 'package:logging/logging.dart';
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

  List<Unit> _units = [];

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

  Logger get _log {
    final Logger log = Logger('_AllUnitsScreenState');
    log.level = Level.ALL;
    return log;
  }

  // TODO on hovering over a # P entry, show a small window with the name and ESR of each crew member onboard
  void _onPersonnelHover(PointerEvent details, Unit unit) {
    _log.finer('Hovering over #P for ${unit.callsign}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Units')),
      body: SingleChildScrollView(
        // TODO make DataTable whole available width
        child: ListenableBuilder(
          listenable: widget.viewModel.loadUnits,
          builder: (context, child) {
            // If command is running, show progress indicator
            if (widget.viewModel.loadUnits.running) {
              return const Center(child: CircularProgressIndicator());
            }

            if (widget.viewModel.loadUnits.completed) {
              _units = widget.viewModel.units;
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
          // TODO add toolbar with optional filters e.g. to only show C1-capable units (i.e. non-patient committed and not assigned to C1/L1), or just CFRs.
          child: DataTable(
            sortAscending: true,
            // TODO implement sorting by status then by Time
            // TODO implement user-settable sorting by multiple fields
            sortColumnIndex: 4, // Sort by Status
            columns: <DataColumn>[
              // Callsign
              DataColumn(label: Text('Callsign')),
              // Type (vehicle type)
              DataColumn(label: Text('Type')),
              // Number of personnel on vehicle
              DataColumn(label: Text('# P')),
              // MBW
              DataColumn(label: Text('MBW')),
              // EOS
              DataColumn(label: Text('EOS')),
              // Status
              DataColumn(
                label: Text('Status'),
                onSort: (int sortColumnIndex, bool ascending) {
                  // FIXME fix hard-coded value for Status column's index
                  debugPrint('sortColumnIndex: $sortColumnIndex');
                  if (sortColumnIndex == 4) {
                    _units.sort((a, b) => a.status.compareTo(b.status));
                  }
                },
              ),
              // Time (in status)
              DataColumn(label: Text('Time')),
              // Assigned event
              DataColumn(label: Text('Assigned event')),
              // Location
              DataColumn(
                label: Text('Location'),
                columnWidth: FlexColumnWidth(),
              ),
            ],
            rows: widget.viewModel.units.map((Unit unit) {
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
                  DataCell(textColouredByStatus(unit.vehicleType.abbreviation)),
                  // Number of personnel on vehicle
                  DataCell(
                    MouseRegion(
                      onHover: (PointerEvent details) =>
                          _onPersonnelHover(details, unit),
                      child: textColouredByStatus(
                        unit.numberOfPersonnel.toString(),
                      ),
                    ),
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
                      unit.endOfShift != null ? unit.endOfShift!.toHM() : '',
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
            }).toList(),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../../domain/models/unit/unit.dart';
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
      setState(() {});
    });
  }

  WidgetStateProperty<Color> rowColour(Unit unit) =>
      WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        return unit.status.backgroundColour;

        // // TODO if selected, apply a grey colour on top of the base colour
        // if (states.contains(WidgetState.selected)) {
        //   return Colors.grey[400]!;
        // }
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Units')),
      body: SingleChildScrollView(
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
              DataColumn(label: Text('Callsign')),
              DataColumn(label: Text('Type')),
              // // TODO implement display of number of personnel on vehicle
              // DataColumn(label: Text('# P')),
              DataColumn(label: Text('MBW')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Time')),
            ],
            rows:
                widget.viewModel.units
                    ?.map(
                      (Unit unit) => DataRow(
                        color: rowColour(unit),
                        cells: [
                          DataCell(Text(unit.callsign)),
                          DataCell(Text(unit.vehicleType.abbreviation)),
                          DataCell(
                            Text(
                              unit.mealBreakWindow != null
                                  ? unit.mealBreakWindow.toString()
                                  : '',
                            ),
                          ),
                          DataCell(Text(unit.status.abbreviation)),
                          DataCell(Text(unit.timeInStatus.toHMS())),
                        ],
                      ),
                    )
                    .toList() ??
                [],
          ),
        ),
      ),
    );
  }
}

extension ToHMS on Duration {
  String toHMS() {
    final String hours = inHours.toString().padLeft(2, '0');
    final String minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final String seconds = (inSeconds.remainder(60)).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}

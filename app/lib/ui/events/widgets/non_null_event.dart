import 'package:gap/gap.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/unit/unit.dart';
import '../../home/view_models/home_viewmodel.dart';
import '../../unit/unit_status_colour.dart';
import '../view_models/single_event_screen_viewmodel.dart';
import 'patient_details.dart';
import 'remarks_log.dart';
import 'single_event_screen.dart';

class NonNullEvent extends StatelessWidget {
  NonNullEvent({
    super.key,
    required this.eventMode,
    required this.viewModel,
    required this.homeViewModel,
    required this.patientControllers,
  });

  final EventMode eventMode;
  final HomeViewModel homeViewModel;
  final PatientControllers patientControllers;
  // final GlobalKey<FormState> patientFormKey;
  final SingleEventScreenViewModel viewModel;

  final Logger _log = Logger('NonNullEvent')..level = Level.ALL;

  @override
  Widget build(BuildContext context) {
    final Event event = homeViewModel.selectedEvent!;

    _log.finer('NonNullEvent eventMode: $eventMode');
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListenableBuilder(
          listenable: homeViewModel,
          builder: (BuildContext context, Widget? child) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(12),
              _Overview(event: event, log: _log),
              const Gap(30),
              _Location(event: event),
              const Gap(30),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) =>
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Buttons(event: event),
                        SizedBox(width: constraints.maxWidth / 3),
                        _AllocatedUnitsTable(
                          units: homeViewModel.selectedEvent!.assignedUnits,
                        ),
                      ],
                    ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 8),
                child: const Divider(),
              ),
              PatientDetails(
                eventMode: eventMode,
                patientControllers: patientControllers,
                viewModel: viewModel,
                homeViewModel: homeViewModel,
              ),
              const Gap(50),
              RemarksLog(event: event, viewModel: viewModel),
            ],
          ),
        ),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
          onPressed: () => debugPrint('Find AED'),
          child: Text(
            'Find AED',
            style: Theme.of(context).textTheme.bodyMedium!
                .copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _Location extends StatelessWidget {
  const _Location({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          event.address?.toString() ?? 'No address',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.event, required this._log});

  final Event event;
  final Logger _log;

  @override
  Widget build(BuildContext context) {
    _log.info('Building _Overview with event: ${event.idLastFour}');
    return Center(
      child: Table(
        children: [
          TableRow(
            children: [
              Text(
                (event.noc != null)
                    ? event.noc!.description
                    : event.status.toString(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AllocatedUnitsTable extends StatelessWidget {
  const _AllocatedUnitsTable({required this.units});

  final List<Unit> units;

  final double _horizontalPadding = 12.0;
  final double _verticalPadding = 8.0;

  @override
  Widget build(BuildContext context) {
    final TextStyle headingsStyle = Theme.of(context).textTheme.bodyLarge!
        .copyWith(fontWeight: FontWeight.bold);

    // Sort the units into ascending order by unit status.
    units.sort((a, b) => a.status.compareTo(b.status));

    return Padding(
      padding: EdgeInsets.fromLTRB(
        _horizontalPadding,
        _verticalPadding,
        _horizontalPadding,
        _verticalPadding,
      ),
      child: Table(
        columnWidths: <int, TableColumnWidth>{
          0: FixedColumnWidth(60),
          1: FixedColumnWidth(60),
        },
        children: [
          // Header row
          TableRow(
            children: [
              Text('Unit', style: headingsStyle),
              Text('Status', style: headingsStyle),
            ],
          ),
          // For each unit, built a TableRow showing the unit's callsign and status.
          // The unit's row is colour-coded to match the unit's status.
          ...units.map((Unit unit) {
            final TextStyle unitStyle = TextStyle(
              color: unit.status.backgroundColour,
              fontWeight: FontWeight.w500,
            );
            return TableRow(
              children: [
                Text(unit.callsign, style: unitStyle),
                Text(unit.status.abbreviation, style: unitStyle),
              ],
            );
          }),
        ],
      ),
    );
  }
}

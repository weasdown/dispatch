import 'package:gap/gap.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/person/patient.dart';
import '../view_models/single_event_screen_viewmodel.dart';
import 'remarks_log.dart';

class NonNullEvent extends StatelessWidget {
  const NonNullEvent({
    super.key,
    required this.event,
    required this.eventMode,
    required this.log,
    required this.viewModel,
  });

  final Event event;
  final EventMode eventMode;
  final Logger log;
  final SingleEventScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: Align(
          alignment: AlignmentGeometry.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(12),
                _Overview(event: event, log: log),
                const Gap(30),
                _Location(event: event),
                const Gap(30),
                _Buttons(event: event),
                const Gap(50),
                _PatientDetails(event: event, viewModel: viewModel),
                const Gap(50),
                RemarksLog(event: event, viewModel: viewModel),
              ],
            ),
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
        Text(event.address, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.event, required this.log});

  final Event event;
  final Logger log;

  @override
  Widget build(BuildContext context) {
    log.info('Building _Overview with event: ${event.idLastFour}');
    return Center(
      child: Table(
        children: [
          TableRow(
            children: [
              Text(
                (event.noc != null)
                    ? '${event.category.toString()}: ${event.noc!.description}'
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

class _PatientDetails extends StatelessWidget {
  const _PatientDetails({required this.event, required this.viewModel});

  final Event event;

  final SingleEventScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    debugPrint('_PatientDetails got event ${event.idLastFour}');

    final List<Patient> pts = event.patients;
    final Patient? firstPatient = pts.isEmpty ? null : pts.first;

    final NumberOfPatients numberOfPatients = event.numberOfPatients;
    final bool singlePatientOrNone =
        (numberOfPatients == NumberOfPatients.none) ||
        (numberOfPatients == NumberOfPatients.one);

    debugPrint('singlePatientOrNone: $singlePatientOrNone');
    debugPrint('viewModel.mode.isEditable: ${viewModel.mode.isEditable}');

    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: singlePatientOrNone
            ? Table(
                children: [
                  TableRow(
                    children: [
                      Text('Name'),
                      viewModel.mode.isEditable
                          // TODO implement form field for entering and setting patient's name
                          ? TextFormField()
                          : Text(
                              numberOfPatients == NumberOfPatients.one
                                  ? firstPatient!.name ?? 'No name for patient'
                                  : 'No patient',
                            ),
                    ],
                  ),
                ],
              )
            :
              // TODO implement display of multiple patients, as a ListView with an ExpansionTile for each patient.
              //  Make the ListView have a fixed height to not push the remarks table down too far.
              // Multiple patients
              Placeholder(),
      ),
    );
  }
}

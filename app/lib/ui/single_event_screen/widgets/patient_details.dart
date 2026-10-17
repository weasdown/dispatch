import 'package:gap/gap.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/person/patient.dart';
import '../view_models/single_event_screen_viewmodel.dart';

Logger get _log {
  final Logger log = Logger('PatientDetails');
  log.level = Level.ALL;
  return log;
}

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

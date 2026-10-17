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

class PatientDetails extends StatefulWidget {
  const PatientDetails({super.key, required this.viewModel});

  final SingleEventScreenViewModel viewModel;

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  Event get event => widget.viewModel.event!;

  EventMode? eventMode;

  @override
  Widget build(BuildContext context) {
    _log.fine('_PatientDetails got event ${event.idLastFour}');

    final Patient? firstPatient = event.patients.firstOrNull;

    // final NumberOfPatients numberOfPatients = event.numberOfPatients;
    // final bool singlePatientOrNone =
    //     (numberOfPatients == NumberOfPatients.none) ||
    //     (numberOfPatients == NumberOfPatients.one);

    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: switch (event.numberOfPatients) {
          NumberOfPatients.none => _NoPatient(
            eventMode: eventMode!,
            viewModel: widget.viewModel,
          ),
          NumberOfPatients.one => _OnePatient(
            eventMode: eventMode!,
            patient: firstPatient!,
            viewModel: widget.viewModel,
          ),
          NumberOfPatients.multiple => _MultiplePatients(eventMode: eventMode!),
        },
      ),
    );

    // return ListenableBuilder(
    //   listenable: Listenable.merge([
    //     widget.viewModel.getMode,
    //     widget.viewModel.load,
    //   ]),
    //   builder: (BuildContext context, Widget? child) {
    //     if (widget.viewModel.getMode.running || widget.viewModel.load.running) {
    //       return const Center(child: CircularProgressIndicator());
    //     } else {
    //       if (widget.viewModel.getMode.error) {
    //         final errorResult =
    //             widget.viewModel.getMode.result as Error<EventMode>;
    //         final error = errorResult.error;
    //         _log.severe(error);
    //         return Expanded(child: ErrorWidget(error));
    //       }
    //       if (widget.viewModel.getMode.completed) {
    //         _log.info(
    //           'widget.viewModel.getMode.completed = ${widget.viewModel.getMode.completed}',
    //         );
    //         Result eventModeResult = widget.viewModel.getMode.result!;
    //         if (eventModeResult is Error<EventMode>) {
    //           return Expanded(child: ErrorWidget(eventModeResult.error));
    //         } else {
    //           eventMode = (eventModeResult as Ok<EventMode>).value;
    //         }
    //       }
    //     }
    //
    //     // TODO remove logging
    //     _log.fine('singlePatientOrNone: $singlePatientOrNone');
    //     _log.fine('viewModel.mode.isEditable: ${eventMode!.isEditable}');
    //
    //    return Placeholder();
    //   },
    // );
  }
}

// TODO implement _NoPatient
class _NoPatient extends StatelessWidget {
  const _NoPatient({required this.eventMode, required this.viewModel});

  final EventMode eventMode;
  final SingleEventScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return _PatientInfoTable(
      eventMode: eventMode,
      patient: null,
      viewModel: viewModel,
    );
  }
}

class _OnePatient extends StatelessWidget {
  const _OnePatient({
    required this.eventMode,
    required this.patient,
    required this.viewModel,
  });

  final EventMode eventMode;

  final Patient patient;

  final SingleEventScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return _PatientInfoTable(
      eventMode: eventMode,
      patient: patient,
      viewModel: viewModel,
    );
  }
}

class _MultiplePatients extends StatelessWidget {
  const _MultiplePatients({required this.eventMode});

  final EventMode eventMode;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _PatientInfoTable extends StatefulWidget {
  const _PatientInfoTable({
    required this.eventMode,
    required this.patient,
    required this.viewModel,
  });

  final EventMode eventMode;

  final Patient? patient;

  final SingleEventScreenViewModel viewModel;

  @override
  State<_PatientInfoTable> createState() => _PatientInfoTableState();
}

class _PatientInfoTableState extends State<_PatientInfoTable> {
  final TextEditingController patientNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.viewModel.load,
        widget.viewModel.createPatient,
        widget.viewModel.updatePatient,
      ]),
      builder: (BuildContext context, Widget? child) {
        return Table(
          columnWidths: {0: FlexColumnWidth(), 1: FlexColumnWidth()},
          children: [
            TableRow(
              children: [
                Text('Name'),
                widget.eventMode.isEditable
                    // TODO implement form field for entering and setting patient's name
                    ? Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: patientNameController,
                            ),
                          ),
                          const Gap(8),
                          ElevatedButton(
                            onPressed: () {
                              final String newName = patientNameController.text;
                              // TODO set pt name for real
                              _log.info('Setting patient name to $newName');
                              Patient newPatient;
                              if (widget.patient == null) {
                                _log.info(
                                  'No patient current exists for event ${widget.viewModel.event!.idLastFour} - creating new patient',
                                );
                                newPatient = Patient(name: newName);
                              } else {
                                newPatient = widget.patient!..name = newName;
                              }

                              _log.finer(
                                'Calling viewModel.updatePatient() to setting new patient',
                              );
                              widget.viewModel.updatePatient.execute(
                                newPatient,
                              );
                            },
                            child: Icon(Icons.check, color: Colors.green),
                          ),
                        ],
                      )
                    : Text(
                        (widget.patient == null)
                            ? ''
                            : widget.patient?.name ?? 'No name for patient',
                      ),
              ],
            ),
          ],
        );
      },
    );
  }
}

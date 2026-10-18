import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/person/patient.dart';
import '../view_models/single_event_screen_viewmodel.dart';
import 'patient_info_table.dart';
import 'single_event_screen.dart';

Logger get _log => Logger('PatientDetails')..level = Level.ALL;

class PatientDetails extends StatefulWidget {
  const PatientDetails({
    super.key,
    required this.eventMode,
    required this.patientControllers,
    required this.viewModel,
  });

  final EventMode eventMode;

  // TODO move patientControllers into viewModel.
  final PatientControllers patientControllers;

  final SingleEventScreenViewModel viewModel;

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  Event get event => widget.viewModel.event!;

  @override
  Widget build(BuildContext context) {
    final EventMode eventMode = widget.eventMode;

    _log.fine('Got event ${event.idLastFour}');
    _log.fine('Got event mode $eventMode');

    final Patient? firstPatient = event.patients.firstOrNull;

    // final NumberOfPatients numberOfPatients = event.numberOfPatients;
    // final bool singlePatientOrNone =
    //     (numberOfPatients == NumberOfPatients.none) ||
    //     (numberOfPatients == NumberOfPatients.one);

    return Expanded(
      child: SingleChildScrollView(
        child: DecoratedBox(
          decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: switch (event.numberOfPatients) {
              NumberOfPatients.none => _NoPatient(
                eventMode: eventMode,
                patientControllers: widget.patientControllers,
                viewModel: widget.viewModel,
              ),
              NumberOfPatients.one => _OnePatient(
                eventMode: eventMode,
                patient: firstPatient!,
                patientControllers: widget.patientControllers,
                viewModel: widget.viewModel,
              ),
              NumberOfPatients.multiple => _MultiplePatients(
                eventMode: eventMode,
              ),
            },
          ),
        ),
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
  const _NoPatient({
    required this.eventMode,
    required this.patientControllers,
    required this.viewModel,
  });

  final EventMode eventMode;
  final PatientControllers patientControllers;
  final SingleEventScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return PatientInfoTable(
      eventMode: eventMode,
      patient: null,
      patientControllers: patientControllers,
      viewModel: viewModel,
    );
  }
}

class _OnePatient extends StatefulWidget {
  const _OnePatient({
    required this.eventMode,
    required this.patient,
    required this.patientControllers,
    required this.viewModel,
  });

  final EventMode eventMode;

  final Patient patient;
  final PatientControllers patientControllers;

  final SingleEventScreenViewModel viewModel;

  @override
  State<_OnePatient> createState() => _OnePatientState();
}

class _OnePatientState extends State<_OnePatient> {
  late Patient _patient;

  @override
  Widget build(BuildContext context) {
    _patient = widget.patient;
    _log.finer('_OnePatient has eventMode: ${widget.eventMode}');
    return PatientInfoTable(
      eventMode: widget.eventMode,
      patient: _patient,
      viewModel: widget.viewModel,
      patientControllers: widget.patientControllers,
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

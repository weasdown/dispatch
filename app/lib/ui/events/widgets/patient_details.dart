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

  void _onChanged(String? newValue) {
    _log.finer('In _onChanged');
    widget.viewModel.setPatientEdited();
  }

  @override
  Widget build(BuildContext context) {
    final EventMode eventMode = widget.eventMode;

    final int numberOfPatients = event.patients.length;

    _log.fine('Got event ${event.idLastFour}');
    _log.fine('Got event mode $eventMode');
    _log.fine(
      'Found $numberOfPatients patient${numberOfPatients == 1 ? '' : 's'}',
    );

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
                onChanged: _onChanged,
              ),
              NumberOfPatients.one || NumberOfPatients.multiple => _OnePatient(
                eventMode: eventMode,
                patient: firstPatient!,
                patientControllers: widget.patientControllers,
                viewModel: widget.viewModel,
                onChanged: _onChanged,
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
    required this.onChanged,
  });

  final EventMode eventMode;
  final ValueChanged<String>? onChanged;
  final PatientControllers patientControllers;
  final SingleEventScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return PatientInfoTable(
      eventMode: eventMode,
      patient: null,
      patientControllers: patientControllers,
      viewModel: viewModel,
      onChanged: onChanged,
    );
  }
}

class _OnePatient extends StatefulWidget {
  const _OnePatient({
    required this.eventMode,
    required this.patient,
    required this.patientControllers,
    required this.viewModel,
    required this.onChanged,
  });

  final EventMode eventMode;

  final ValueChanged<String>? onChanged;

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
      onChanged: widget.onChanged,
    );
  }
}

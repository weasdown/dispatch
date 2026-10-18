import 'package:dispatch/ui/single_event_screen/widgets/single_event_screen.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/person/patient.dart';
import '../view_models/single_event_screen_viewmodel.dart';

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

    return DecoratedBox(
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
          NumberOfPatients.multiple => _MultiplePatients(eventMode: eventMode),
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
    return _PatientInfoTable(
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
    return Consumer<EventModeModel>(
      builder: (BuildContext context, EventModeModel value, Widget? child) {
        return _PatientInfoTable(
          eventMode: widget.eventMode,
          patient: _patient,
          viewModel: widget.viewModel,
          patientControllers: widget.patientControllers,
        );
      },
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
    required this.patientControllers,
  });

  final EventMode eventMode;

  final Patient? patient;

  final PatientControllers patientControllers;

  final SingleEventScreenViewModel viewModel;

  @override
  State<_PatientInfoTable> createState() => _PatientInfoTableState();
}

class _PatientInfoTableState extends State<_PatientInfoTable> {
  final _formKey = GlobalKey<FormState>();

  final Logger log = Logger('_PatientInfoTable')..level = Level.ALL;

  // final TextEditingController patientNameTextController =
  //     TextEditingController();

  // final WidgetStatesController patientNameButtonController =
  //     WidgetStatesController();

  // Map<String,bool> isEditingField = {'name': };

  TextEditingController get nameController =>
      widget.patientControllers.nameController;

  bool _patientNameIsSet = true;
  void onSetPatientName() {
    final String newName = nameController.text;

    log.info('Setting patient name to $newName');
    Patient newPatient;
    if (widget.patient == null) {
      log.info(
        'No patient current exists for event ${widget.viewModel.event!.idLastFour} - creating new patient',
      );
      newPatient = Patient(name: newName);
    } else {
      newPatient = widget.patient!..name = newName;
    }

    log.finer('Calling viewModel.updatePatient() to setting new patient');
    widget.viewModel.updatePatient.execute(newPatient);

    setState(() {
      _patientNameIsSet = true;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   patientNameController.addListener(_printLatestValue);
  // }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.viewModel.load,
        widget.viewModel.createPatient,
        widget.viewModel.updatePatient,
      ]),
      builder: (BuildContext context, Widget? child) {
        log.finer('Got eventMode: ${widget.eventMode}');

        return Form(
          key: _formKey,
          child: Table(
            columnWidths: {0: FlexColumnWidth(), 1: FlexColumnWidth()},
            children: [
              TableRow(
                children: [
                  Text('Name'),
                  widget.eventMode.isEditable
                      // TODO implement form field for entering and setting patient's name
                      ? Row(
                          children: [
                            _PatientNameValue(
                              patient: widget.patient!,
                              patientNameController: nameController,
                              isEditing: _patientNameIsSet,
                            ),
                            // const Gap(8),
                            // ElevatedButton(
                            //   // statesController: patientNameButtonController,
                            //   onPressed: () => onSetPatientName(),
                            //   child: Icon(Icons.check, color: Colors.green),
                            // ),
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
          ),
        );
      },
    );
  }
}

class _PatientNameValue extends StatelessWidget {
  const _PatientNameValue({
    required this.patient,
    required this.patientNameController,
    required this.isEditing,
  });

  final bool isEditing;
  final Patient patient;
  final TextEditingController patientNameController;

  @override
  Widget build(BuildContext context) {
    return isEditing
        ? Expanded(child: TextFormField(controller: patientNameController))
        : Text(patientNameController.text);
  }
}

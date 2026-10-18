import 'package:flutter/services.dart' show MaxLengthEnforcement;
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/location/address.dart';
import '../../../domain/models/person/gp_practice.dart';
import '../../../domain/models/person/patient.dart';
import '../../../utils/capitalise.dart';
import '../view_models/single_event_screen_viewmodel.dart';
import 'single_event_screen.dart';

class PatientInfoTable extends StatefulWidget {
  const PatientInfoTable({
    super.key,
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
  State<PatientInfoTable> createState() => _PatientInfoTableState();
}

class _PatientInfoTableState extends State<PatientInfoTable> {
  final _formKey = GlobalKey<FormState>();

  final Logger log = Logger('_PatientInfoTable')..level = Level.ALL;

  // final TextEditingController patientNameTextController =
  //     TextEditingController();

  // final WidgetStatesController patientNameButtonController =
  //     WidgetStatesController();

  // Map<String,bool> isEditingField = {'name': };

  TextEditingController get nameController =>
      widget.patientControllers.nameController;

  // bool _patientNameIsSet = true;
  // void onSetPatientName() {
  //   final String newName = nameController.text;
  //
  //   log.info('Setting patient name to $newName');
  //   Patient newPatient;
  //   if (widget.patient == null) {
  //     log.info(
  //       'No patient current exists for event ${widget.viewModel.event!.idLastFour} - creating new patient',
  //     );
  //     newPatient = Patient(name: newName);
  //   } else {
  //     newPatient = widget.patient!..name = newName;
  //   }
  //
  //   log.finer('Calling viewModel.updatePatient() to setting new patient');
  //   widget.viewModel.updatePatient.execute(newPatient);
  //
  //   setState(() {
  //     _patientNameIsSet = true;
  //   });
  // }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

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

        final bool isEditable = widget.eventMode.isEditable;

        return Form(
          key: _formKey,
          child: Table(
            columnWidths: {0: FlexColumnWidth(), 1: FlexColumnWidth()},
            children: patientInfoFields(
              viewModel: widget.viewModel,
              patient: widget.patient,
              isEditable: isEditable,
            ).map((PatientInfoTableField field) => field.tableRow()).toList(),
          ),
        );
      },
    );
  }
}

class PatientInfoTableField<T> extends TableRow {
  PatientInfoTableField({
    required this.patient,
    required this.name,
    required this.value,
    required this.isEditable,
    FormFieldValidator<String>? validator,
    this.maxLength,
  }) : controller = TextEditingController(
         text: (patient == null) ? '' : value(patient)?.toString() ?? '',
       ),
       maxLengthEnforcement = (maxLength == null)
           ? null
           : MaxLengthEnforcement.enforced,
       validator = validator ?? _defaultValidator;

  final TextEditingController controller;
  final bool isEditable;
  final String name;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final FormFieldValidator<String> validator;
  final Patient? patient;
  final T? Function(Patient) value;

  static FormFieldValidator<String> get _defaultValidator => (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    return null;
  };

  TableRow tableRow() {
    return TableRow(
      children: [
        Text(name.capitalise()),
        isEditable
            // TODO change TextFormField to a widget appropriate for value type T, e.g. set of TextFormFields for setting an address.
            ? TextFormField(
                controller: controller,
                validator: validator,
                maxLength: maxLength,
              )
            : Text(
                (patient == null)
                    ? ''
                    : value(patient!)?.toString() ?? 'No $name for patient',
              ),
      ],
    );
  }
}

List<PatientInfoTableField> patientInfoFields({
  required SingleEventScreenViewModel viewModel,
  required Patient? patient,
  required bool isEditable,
}) => [
  // Name field
  PatientInfoTableField<String>(
    patient: patient,
    name: 'name',
    value: (Patient p) => p.name,
    isEditable: isEditable,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter some text';
      }
      return null;
    },
  ),
  // Age field
  PatientInfoTableField<int>(
    patient: patient,
    name: 'age',
    value: (Patient p) => p.age,
    maxLength: 3,
    isEditable: isEditable,
  ),
  // DOB field
  PatientInfoTableField<DateTime>(
    patient: patient,
    name: 'DOB',
    value: (Patient p) => p.dateOfBirth,
    isEditable: isEditable,
  ),
  // Home address field
  PatientInfoTableField<Address>(
    patient: patient,
    name: 'home address',
    value: (Patient p) => p.homeAddress,
    isEditable: isEditable,
  ),
  // GP practice field
  PatientInfoTableField<GPPractice>(
    patient: patient,
    name: 'GP practice',
    value: (Patient p) => p.gpPractice,
    isEditable: isEditable,
  ),
];

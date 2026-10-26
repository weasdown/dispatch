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
    required this.onChanged,
  });

  final EventMode eventMode;

  final ValueChanged<String>? onChanged;

  final Patient? patient;

  final PatientControllers patientControllers;

  final SingleEventScreenViewModel viewModel;

  @override
  State<PatientInfoTable> createState() => _PatientInfoTableState();
}

class _PatientInfoTableState extends State<PatientInfoTable> {
  // final _formKey = GlobalKey<FormState>();

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

  // FIXME when dispose() uncommented, error about controller disposal being thrown when switching event modes.
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

        // Patient form
        return Form(
          key: SingleEventScreen.patientFormKey,
          child: Table(
            columnWidths: {0: FlexColumnWidth(), 1: FlexColumnWidth()},
            children: patientInfoFields(
              patientControllers: widget.patientControllers,
              viewModel: widget.viewModel,
              patient: widget.patient,
              isEditable: isEditable,
              onChanged: widget.onChanged,
            ),
          ),
        );
      },
    );
  }
}

class PatientInfoTableField<T> extends TableRow {
  const PatientInfoTableField({
    required this.controller,
    required this.patient,
    required this.name,
    required this.value,
    required this.isEditable,
    this.validator,
    this.maxLength,
  }) : //  controller = TextEditingController(
       //   text: (patient == null) ? '' : value(patient)?.toString() ?? '',
       // ),
       maxLengthEnforcement = (maxLength == null)
           ? null
           : MaxLengthEnforcement.enforced;

  final TextEditingController controller;
  final bool isEditable;
  final String name;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final Patient? patient;
  final FormFieldValidator<String>? validator;
  final T? Function(Patient) value;

  TableRow tableRow() {
    // FIXME fix centering of field name - should be left centre.
    return TableRow(
      children: [
        Align(
          alignment: AlignmentGeometry.centerLeft,
          child: Text(name.capitalise()),
        ),
        Align(
          alignment: AlignmentGeometry.bottomCenter,
          child: isEditable
              // TODO change TextFormField to a widget appropriate for value type T, e.g. set of TextFormFields for setting an address.
              ? TextFormField(
                  controller: controller,
                  validator: validator,
                  maxLength: maxLength, // TODO hide display of max length (e.g. 1/3) below field
                  // onChanged: onChanged, // FIXME fix running of viewModel.setEventEdited while maintaining new text value on screen - value is currently overwritten by setState()
                  // initialValue: () {
                  //   _log.finer('controller: $controller');
                  //   _log.finer('controller.text: "${controller.text}"');
                  //   return controller.text;
                  // }(),
                )
              : Text(
                  (patient == null) ? '' : value(patient!)?.toString() ?? '',
                ),
        ),
      ],
    );
  }
}

// TODO add a PatientFormField with _GPPracticeForm to patientInfoFields
class _GPPracticeForm extends StatefulWidget {
  const _GPPracticeForm(
    // {super.key}
  );

  @override
  State<_GPPracticeForm> createState() => _GPPracticeFormState();
}

// TODO implement _GPPracticeFormState with a Form with Texts/TextFormFields for GPPractice()'s arguments.
class _GPPracticeFormState extends State<_GPPracticeForm> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

List<TableRow> patientInfoFields({
  required PatientControllers patientControllers,
  required SingleEventScreenViewModel viewModel,
  required Patient? patient,
  required bool isEditable,
  required ValueChanged<String>? onChanged,
}) => [
  // Name field
  PatientInfoTableField<String>(
    controller: patientControllers.nameController,
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
    // onChanged: onChanged,
  ).tableRow(),
  // Age field
  PatientInfoTableField<int>(
    controller: patientControllers.ageController,
    patient: patient,
    name: 'age',
    value: (Patient p) => p.age,
    maxLength: 3,
    isEditable: isEditable,
    validator: (value) {
      // Accept empty string.
      if (value == null || value.isEmpty) {
        return null;
      }

      if (int.tryParse(value) == null) {
        return 'Please enter a whole number';
      }
      return null;
    },
    // onChanged: onChanged,
  ).tableRow(),
  // DOB field
  PatientInfoTableField<DateTime>(
    controller: patientControllers.dobController,
    patient: patient,
    name: 'DOB',
    value: (Patient p) => p.dateOfBirth,
    isEditable: isEditable,
    // onChanged: onChanged,
  ).tableRow(),
  // Home address field
  PatientInfoTableField<Address>(
    controller: patientControllers.homeAddressController,
    patient: patient,
    name: 'home address',
    value: (Patient p) => p.homeAddress,
    isEditable: isEditable,
    // onChanged: onChanged,
  ).tableRow(),
  // GP practice field
  PatientInfoTableField<GPPractice>(
    controller: patientControllers.gpPracticeController,
    patient: patient,
    name: 'GP practice',
    value: (Patient p) => p.gpPractice,
    isEditable: isEditable,
    // onChanged: onChanged,
  ).tableRow(),
];

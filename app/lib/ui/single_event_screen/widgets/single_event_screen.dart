import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/category.dart';
import '../../../domain/models/event/event.dart';
import '../../../domain/models/event/status.dart';
import '../../../domain/models/location/address.dart';
import '../../../domain/models/person/gp_practice.dart';
import '../../../domain/models/person/patient.dart';
import '../view_models/single_event_screen_viewmodel.dart';
import 'event_mode_button.dart';
import 'non_null_event.dart';
import 'null_event.dart';

class SingleEventScreen extends StatefulWidget {
  const SingleEventScreen({super.key, required this.viewModel});

  static final patientFormKey = GlobalKey<FormState>();

  final SingleEventScreenViewModel viewModel;

  @override
  State<SingleEventScreen> createState() => _SingleEventScreenState();
}

class _SingleEventScreenState extends State<SingleEventScreen> {
  // bool _editing = false;

  late final EventControllers _eventControllers = EventControllers(
    eventMode: widget.viewModel.eventMode,
    onSetEventModified: updateEventModified,
  );

  late EventMode _eventMode;

  void onAcceptEvent() {
    _log.finer('In onAcceptEvent');
    // _log.finer('Patient has been edited? ${widget.viewModel.patientEdited}');
    _log.finer('Event has been edited? ${widget.viewModel.eventEdited}');
    // Event and/or patient has been edited
    if (widget.viewModel.eventEdited || widget.viewModel.patientEdited) {
      _log.finer(
        'Patient and/or event has been edited - skipping updating as required',
      );
      _log.info('Updating patient');
      onUpdatePatient();

      _log.info('Updating event');
      onUpdateEvent();

      _log.info('Event and patient updated');

      widget.viewModel.updateEventMode(.select);
    }
    // Neither event nor patient has been edited
    else {
      _log.finer(
        'Patient and event have not been edited at all - skipping updates',
      );
      widget.viewModel.updateEventMode(.select);
      return;
    }
  }

  // late EventMode _eventMode;

  // TODO when going from Update/Create to Select, set update patient's details to those from _patientControllers
  void onEventModeUpdate(EventMode newMode) {
    // TODO If new mode is Select, update patient's details based on the contents of the form in _PatientInfoTableState.

    final EventMode oldMode = _eventMode;

    final Event? event = widget.viewModel.event;

    _log.info('Switching from ${oldMode.toString()} to ${newMode.toString()}');

    switch ((oldMode, newMode)) {
      case (EventMode.select, EventMode.update):
        onSelectToUpdate();

      case (EventMode.update, EventMode.select):
        onUpdateToSelect(event);

      case (EventMode.select, EventMode.select) ||
          (EventMode.create, EventMode.create) ||
          (EventMode.update, EventMode.update):
        _log.finer(
          'Tried to switch from ${oldMode.toString()} to ${newMode.toString()} but this is a NoOp',
        );
      // Do nothing

      case (_, _):
        // TODO: Handle with cases above.
        throw UnimplementedError(
          'Switching from ${oldMode.toString()} to ${newMode.toString()} is not yet implemented.',
        );
    }

    setState(() {
      _eventMode = newMode;
      if (newMode.isEditable) {
        // _editing = true;
        _log.finer('Entered editable mode');
        _patientControllers.startEditingName();
      } else {
        // _editing = false;
        _log.finer('Exited editable mode');
        _patientControllers.stopEditingName();
      }
    });
    _log.fine('Set _eventMode to $_eventMode');
  }

  /// When switching from Select to Update:
  /// - Save current event parameters to the viewModel.
  /// Rebuild patient details table with EventMode.update:
  ///   - Sets each field's value widget to a TextFormField with a value equal to the current event's value for the field.
  /// Once any changes made to event parameters, run viewModel.eventEdited.execute() to show the event has been modified.
  /// Rebuild _SingleEventScreenState with EventMode.update:
  /// - Show Accept Event button.
  ///   - On pressed, set event in viewModel to displayed parameters (get from TextEditingControllers). Set event mode to Select.
  void onSelectToUpdate() {
    _log.finer('Changing _eventMode from Select to Update in onSelectToUpdate');
    // TODO remove viewModel.setOldEventBeforeEditing - instead will build new event here then compare against old one (rather than save old one and assume the new one).
    // widget.viewModel.setOldEventBeforeEditing.execute();

    setState(() {
      _eventMode = .update;
      widget.viewModel.updateEventMode(_eventMode);
    });
  }

  Future<void> onUpdateEvent() async {
    _log.finer('In onUpdateEvent');
    _log.severe('onUpdateEvent() is not yet fully implemented.');

    // TODO implement building of newEvent using copyWith with values from eventControllers
    final Event newEvent =
        widget.viewModel.event?.copyWith() ??
        Event.preAlert(idNum: widget.viewModel.nextEventID, address: null);

    return widget.viewModel.updateEvent.execute(newEvent);
  }

  Future<void> onUpdatePatient() async {
    if (patient != null) {
      if (SingleEventScreen.patientFormKey.currentState!.validate()) {
        // If the form is valid, update the patient stored in the viewModel (and hence its EventRepository).
        _log.fine('Valid patient data received!');

        final Patient newPatient = patient!.copyWith(
          name: _patientControllers.newName() ?? patient?.name,
          age: _patientControllers.newAge() ?? patient?.age,
          dateOfBirth: _patientControllers.newDOB() ?? patient?.dateOfBirth,
          gpPractice:
              _patientControllers.newGPPractice() ?? patient?.gpPractice,
          homeAddress:
              _patientControllers.newHomeAddress() ?? patient?.homeAddress,
        );
        _log.fine('New patient in onUpdatePatient: ${newPatient.toString()}');
        return widget.viewModel.updatePatient.execute(newPatient);
      }
    }
    // Current patient is null, so add a new patient
    else {
      throw UnimplementedError(
        'Adding a new patient in onUpdatePatient is not yet implemented.',
      );
    }
  }

  // FIXME onUpdateToSelect currently throws an error.
  // onUpdateToSelect is used similarly to pressing Accept Event when in Update, except that
  // when clicking Select, the user is suggesting that they *don't* want to keep any new data.
  // This should be checked with a dialog in case they have clicked Select accidentally.
  /// When switching from Update to Select:
  /// - Build new event.
  /// - Compare new event against old event.
  /// - If same:
  ///   - Discard new event.
  ///   - Switch straight to Select.
  /// - If different:
  ///   - Show dialog warning about discarding modifications.
  ///     - On OK: discard new event. Switch straight to Select.
  ///     - On Cancel: close dialog.
  ///
  ///  [currentEvent] can be null in the case where there's no event selected, then the user switches to Update, then straight back to Select.
  void onUpdateToSelect(Event? currentEvent) async {
    // Displays a dialog warning that event modifications will be discarded if the user confirms the switch back to Select.
    Future<void> warnAboutModifiedEventAndOrPatient({
      required bool eventModified,
      required bool patientModified,
    }) async {
      throw UnimplementedError(
        'warningAboutModifiedEvent() is not yet implemented.',
      );
    }

    // TODO get these values from the PatientControllers and EventControllers (once created).
    // TODO add EventControllers class for storing contents of location box, event status etc.
    final Address newAddress = Address();
    final LatLng newLocation = LatLng(0, 0);
    final EventStatus newStatus = EventStatus(Category.one, 'PLACEHOLDER');
    final List<Patient> newPatients = [];

    late final Event? newEvent;

    final Patient? oldPatient = currentEvent?.patients.first;

    bool patientModified = false;
    bool eventModified = false;

    final Patient? newPatient = widget.viewModel.event!.patients.firstOrNull
        ?.copyWith(
          name: _patientControllers.newName(),
          age: _patientControllers.newAge(),
          dateOfBirth: _patientControllers.newDOB(),
          homeAddress: _patientControllers.newHomeAddress(),
          gpPractice: _patientControllers.newGPPractice(),
        );

    if (newPatient != oldPatient) {
      patientModified = true;
    }

    newEvent = currentEvent?.copyWith(
      address: newAddress,
      location: newLocation,
      status: newStatus,
      patients: newPatients,
    );

    if ((currentEvent == null) && (newEvent != null)) {
      eventModified = true;
    } else if (currentEvent != null) {
      // Compare against old values to work out if anything has changed.
      eventModified =
          (currentEvent.address != newAddress) ||
          (currentEvent.location != newLocation) ||
          (currentEvent.status != newStatus) ||
          (currentEvent.patients != newPatients);
    }

    if (eventModified || patientModified) {
      return await warnAboutModifiedEventAndOrPatient(
        eventModified: eventModified,
        patientModified: patientModified,
      );
    } else {
      // Nothing to update
      return;
    }
  }

  Patient? get patient => widget.viewModel.event?.patients.firstOrNull;

  late final PatientControllers _patientControllers = PatientControllers(
    eventMode: widget.viewModel.eventMode,
    // FIXME reinstate something useful here or remove the argument/attribute altogether
    onSetEventModified: () {
      _log.finer('Setting patient edited');
      widget.viewModel.setPatientEdited();
    },
  );

  // List<String>? _patientValues;

  void updateEventModified() {
    _log.finer('In updateEventModified');
    widget.viewModel.setEventEdited();
    _log.finer(
      '- After update, event has been edited? ${widget.viewModel.eventEdited}',
    );
  }

  @override
  void initState() {
    _eventControllers.addListener(updateEventModified);
    _patientControllers.addListener(updateEventModified);
    super.initState();
  }

  @override
  void dispose() {
    _eventControllers.dispose();
    _patientControllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final Result<EventMode> eventModeResult;

    // return FutureBuilder(
    //   initialData: EventMode.select,
    //   future: widget.viewModel.getMode.execute(),
    //   builder: (context, AsyncSnapshot<void> snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       if (snapshot.hasError) {
    //         return ErrorWidget(snapshot.error!);
    //       } else {
    //         return child;
    //       }
    //     } else {
    //       return Center(child: CircularProgressIndicator());
    //     }
    //   },
    // );

    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (BuildContext context, Widget? child) {
        _eventMode = widget.viewModel.eventMode;

        return Scaffold(
          appBar: AppBar(
            title: Text('Event'),
            elevation: 8,
            automaticallyImplyLeading: false,
            actions: [
              // Include the _AcceptEventButton if in EventMode.create/update
              ...?(_eventMode.isEditable)
                  ? [
                      _AcceptEventButton(
                        eventControllers: _eventControllers,
                        patientControllers: _patientControllers,
                        eventModified: widget.viewModel.eventEdited,
                        onPressed: onAcceptEvent,
                        onUpdateEvent: onUpdateEvent,
                        onUpdatePatient: onUpdatePatient,
                        viewModel: widget.viewModel,
                      ),
                    ]
                  : null,
              RadioGroup<EventMode>(
                groupValue: _eventMode,
                onChanged: (EventMode? mode) => onEventModeUpdate(mode!),
                child: Row(
                  children: [
                    // Select button
                    EventModeButton(
                      label: 'Select',
                      value: EventMode.select,
                      onEventModeUpdate: (EventMode? mode) =>
                          onEventModeUpdate(mode!),
                    ),

                    // Create button
                    EventModeButton(
                      label: 'Create',
                      value: EventMode.create,
                      onEventModeUpdate: (EventMode? mode) =>
                          onEventModeUpdate(mode!),
                    ),

                    // Update button
                    EventModeButton(
                      label: 'Update',
                      value: EventMode.update,
                      onEventModeUpdate: (EventMode? mode) =>
                          onEventModeUpdate(mode!),
                      colourOnSelected: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: ListenableBuilder(
            listenable: widget.viewModel.load,
            builder: (context, child) {
              final Logger log = Logger('_SingleEventScreenState');
              return ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, _) {
                  final Event? event = widget.viewModel.event;
                  return (event == null)
                      ? NullEvent(event: event, log: log)
                      : NonNullEvent(
                          event: event,
                          viewModel: widget.viewModel,
                          eventMode: _eventMode,
                          patientControllers: _patientControllers,
                          // patientFormKey: _patientFormKey,
                        ); // event != null
                },
              );
            },
          ),
        );
      },
    );
  }
}

Logger get _log {
  final Logger log = Logger('_SingleEventScreenState');
  log.level = Level.ALL;
  return log;
}

final class EventControllers extends ChangeNotifier {
  EventControllers({required this.eventMode, required this.onSetEventModified});

  final EventMode eventMode;
  final void Function() onSetEventModified;
}

final class PatientControllers extends ChangeNotifier {
  PatientControllers({
    required this.eventMode,
    required this.onSetEventModified,
  }) : ageController = TextEditingController()..addListener(onSetEventModified),
       dobController = TextEditingController()..addListener(onSetEventModified),
       gpPracticeController = TextEditingController()
         ..addListener(onSetEventModified),
       homeAddressController = TextEditingController()
         ..addListener(onSetEventModified),
       nameController = TextEditingController()
         ..addListener(onSetEventModified),
       _isEditingName = eventMode.isEditable;

  final TextEditingController ageController;

  // List<String> get allValues => [
  //   ageController.text,
  //   dobController.text,
  //   gpPracticeController.text,
  //   homeAddressController.text,
  //   nameController.text,
  // ];

  final TextEditingController dobController;

  final EventMode eventMode;

  final TextEditingController gpPracticeController;

  final TextEditingController homeAddressController;

  bool get isEditingName => _isEditingName;
  bool _isEditingName;

  final TextEditingController nameController;

  int? newAge() {
    final String ageString = ageController.text;
    if (ageString == "") {
      return null;
    }
    final int? nullableAge = int.tryParse(ageString);

    // If the ageController had some text but it couldn't parse to an int, the user has entered an invalid value.
    if (nullableAge == null) {
      _log.severe('Invalid value was entered for age: $ageString');
    }
    return nullableAge;
  }

  DateTime? newDOB() {
    final String dobString = dobController.text;
    if (dobString == "") {
      return null;
    }
    final DateTime? nullableDate = DateTime.tryParse(dobString);

    // If the dobController had some text but it couldn't parse to a DateTime, the user has entered an invalid value.
    if ((dobString != "") && (nullableDate == null)) {
      _log.severe('Invalid value was entered for DOB: $dobString');
    }
    return nullableDate;
  }

  GPPractice? newGPPractice() {
    final String gpPracticeString = gpPracticeController.text;
    if (gpPracticeString == "") {
      return null;
    }
    final GPPractice? nullableGPPractice = GPPractice.tryParse(
      gpPracticeString,
    );

    // If the dobController had some text but it couldn't parse to a GPPractice, the user has entered an invalid value.
    if ((gpPracticeString != "") && (nullableGPPractice == null)) {
      _log.severe(
        'Invalid value was entered for GP practice: $gpPracticeString',
      );
    }
    return nullableGPPractice;
  }

  Address? newHomeAddress() {
    final String addressString = homeAddressController.text;
    if (addressString == "") {
      return null;
    }
    final Address? nullableAddress = Address.tryParse(addressString);

    // If the dobController had some text but it couldn't parse to an Address, the user has entered an invalid value.
    if ((addressString != "") && (nullableAddress == null)) {
      _log.severe('Invalid value was entered for home address: $addressString');
    }
    return nullableAddress;
  }

  String? newName() {
    final String newValue = nameController.text;
    _log.finer('New name: $newValue');
    return newValue.toString() == "" ? null : nameController.text;
  }

  // Patient newPatientFromValues(Patient existingPatient) {
  //   // Have to use copyWith for the ID to transfer to the new patient.
  //   return existingPatient.copyWith();
  // }

  final void Function() onSetEventModified;

  void startEditingName() {
    _isEditingName = true;
    notifyListeners();
  }

  void stopEditingName() {
    _isEditingName = false;
    notifyListeners();
  }
}

class _AcceptEventButton extends StatelessWidget {
  const _AcceptEventButton({
    required this.eventControllers,
    required this.patientControllers,
    required this.eventModified,
    required this.onPressed,
    required this.onUpdateEvent,
    required this.onUpdatePatient,
    required this.viewModel,
  });

  final EventControllers eventControllers;
  final bool eventModified;
  final Future<void> Function() onUpdateEvent;
  final Future<void> Function() onUpdatePatient;
  final PatientControllers patientControllers;
  final SingleEventScreenViewModel viewModel;

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text('Accept Event'));
  }
}

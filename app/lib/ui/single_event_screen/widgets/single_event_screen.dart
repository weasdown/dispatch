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

  final SingleEventScreenViewModel viewModel;

  @override
  State<SingleEventScreen> createState() => _SingleEventScreenState();
}

class _SingleEventScreenState extends State<SingleEventScreen> {
  // bool _editing = false;
  EventMode _eventMode = .select;
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
        _log.finer('Started editing');
        _patientControllers.startEditingName();
      } else {
        // _editing = false;
        _log.finer('Stopped editing');
        _patientControllers.stopEditingName();
      }
    });
    _log.fine('Set _eventMode to $_eventMode');
  }

  /// When switching from Select to Update:
  /// - Save current event parameters to the viewModel.
  /// For each field in patient details table:
  ///   - Set field's value widget to a TextFormField with a value equal to the current event's value for the field.
  /// Once any changes made to event parameters, run viewModel.eventEdited.execute() to show the event has been modified.
  /// Show Accept Event button.
  ///   - On pressed, set event in viewModel to displayed parameters (get from TextEditingControllers). Set event mode to Select.
  void onSelectToUpdate() {
    _log.finer('In onSelectToUpdate');
    // TODO remove viewModel.setOldEventBeforeEditing - instead will build new event here then compare against old one (rather than save old one and assume the new one).
    // widget.viewModel.setOldEventBeforeEditing.execute();

    throw UnimplementedError(
      'Switching from Select to Update is not yet implemented.',
    );
  }

  Future<void> onUpdatePatient(Patient newPatient) async {
    widget.viewModel.updatePatient.execute(newPatient);
  }

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

  final PatientControllers _patientControllers = PatientControllers(
    eventMode: .select,
  );

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Event'),
        elevation: 8,
        automaticallyImplyLeading: false,
        actions: [
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
                    ); // event != null
            },
          );
        },
      ),
    );
  }
}

Logger get _log {
  final Logger log = Logger('_SingleEventScreenState');
  log.level = Level.ALL;
  return log;
}

final class PatientControllers extends ChangeNotifier {
  PatientControllers({required this.eventMode})
    : ageController = TextEditingController(),
      dobController = TextEditingController(),
      gpPracticeController = TextEditingController(),
      homeAddressController = TextEditingController(),
      nameController = TextEditingController(),
      _isEditingName = eventMode.isEditable;

  final TextEditingController ageController;
  final TextEditingController dobController;

  final EventMode eventMode;

  final TextEditingController gpPracticeController;

  final TextEditingController homeAddressController;

  bool get isEditingName => _isEditingName;
  bool _isEditingName;

  final TextEditingController nameController;

  int? newAge() {
    final String ageString = ageController.text;
    final int? nullableAge = int.tryParse(ageString);

    // If the ageController had some text but it couldn't parse to an int, the user has entered an invalid value.
    if ((ageString != "") && (nullableAge == null)) {
      _log.severe('Invalid value was entered for age: $ageString');
    }
    return nullableAge;
  }

  DateTime? newDOB() {
    final String dobString = dobController.text;
    final DateTime? nullableDate = DateTime.tryParse(dobString);

    // If the dobController had some text but it couldn't parse to a DateTime, the user has entered an invalid value.
    if ((dobString != "") && (nullableDate == null)) {
      _log.severe('Invalid value was entered for DOB: $dobString');
    }
    return nullableDate;
  }

  GPPractice? newGPPractice() {
    final String gpPracticeString = homeAddressController.text;
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
    final Address? nullableAddress = Address.tryParse(addressString);

    // If the dobController had some text but it couldn't parse to an Address, the user has entered an invalid value.
    if ((addressString != "") && (nullableAddress == null)) {
      _log.severe('Invalid value was entered for home address: $addressString');
    }
    return nullableAddress;
  }

  String? newName() => nameController.text == "" ? null : nameController.text;

  void startEditingName() {
    _isEditingName = true;
    notifyListeners();
  }

  void stopEditingName() {
    _isEditingName = false;
    notifyListeners();
  }
}

// TODO use _AcceptEventButton - show it when SingleEventScreen.eventMode is Create or Update
class _AcceptEventButton extends StatelessWidget {
  const _AcceptEventButton({
    required this.newEvent,
    required this.eventModified,
    required this.newPatient,
    required this.patientModified,
  });

  final bool eventModified;
  final Event newEvent;
  final Patient? newPatient;
  final bool patientModified;

  void updateEvent(Event newEvent) {
    throw UnimplementedError('updateEvent() is not yet implemented');
  }

  void updatePatient(Patient? newPatient) {
    throw UnimplementedError('updatePatient() is not yet implemented');
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _log.info('Updating patient');
        updatePatient(newPatient);
        _log.info('Updating event');
        updateEvent(newEvent);
        _log.info('Event and patient updated');
      },
      child: Text('Accept Event'),
    );
  }
}

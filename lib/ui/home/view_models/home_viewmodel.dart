import 'package:flutter/material.dart';

import '../../../data/repositories/event/event_repository.dart';
import '../../../domain/models/event/event.dart';
import '../../../ui/event/view_models/special_situation_viewmodel.dart';
import '../../../ui/event/widgets/special_situation_button.dart';
import '../../../utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required EventRepository eventRepository,
    // required UserRepository userRepository,
  }) : _eventRepository = eventRepository {
    _load();
  }
  //      _userRepository = userRepository {
  //   load = Command0(_load)..execute();
  //   deleteBooking = Command1(_deleteBooking);
  // }

  final EventRepository _eventRepository;
  // final UserRepository _userRepository;
  // final _log = Logger('HomeViewModel');
  List<Event> _events = [];
  // User? _user;

  // late Command0 load;
  // late Command1<void, int> deleteBooking;

  Widget eventTile(Event event) {
    List<Widget> alertWidgets = [];
    if (event.specialSituation != null) {
      // TODO add special situation button to alertWidgets
      alertWidgets.add(
        // FIXME probably shouldn't be creating a new SpecialSituationViewModel here.
        SpecialSituationButton(
          viewModel: SpecialSituationViewModel(event.specialSituation!),
        ),
      );
    }

    return Card(
      color: event.category.colour,
      child: ListTile(
        leading: SelectableText(
          event.category.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        title: SelectableText('${event.id} - ${event.address}'),
        subtitle: SelectableText(event.status.toString()),
        trailing:
            alertWidgets.isNotEmpty
                ? Row(mainAxisSize: MainAxisSize.min, children: alertWidgets)
                : null,
      ),
    );
  }

  List<Event> get events => _events;

  List<Widget> get eventTiles =>
      List<Widget>.from(_events.map((Event event) => eventTile(event)));

  // User? get user => _user;

  Future<Result> _load() async {
    try {
      final result = await _eventRepository.allEvents;
      switch (result) {
        case Ok<List<Event>>():
          _events = result.value;
          // _log.fine('Loaded bookings');
          return Result.ok(_events);
        case Error<List<Event>>():
          // _log.warning('Failed to load bookings', result.error);
          return result;
      }

      // final userResult = await _userRepository.getUser();
      // switch (userResult) {
      //   case Ok<User>():
      //     _user = userResult.value;
      //     _log.fine('Loaded user');
      //   case Error<User>():
      //   // _log.warning('Failed to load user', userResult.error);
      // }
      //
      // return userResult;
    } finally {
      notifyListeners();
    }
  }

  // Future<Result<void>> _deleteBooking(int id) async {
  //   try {
  //     final resultDelete = await _eventRepository.delete(id);
  //     switch (resultDelete) {
  //       case Ok<void>():
  //         // _log.fine('Deleted booking $id');
  //       case Error<void>():
  //         // _log.warning('Failed to delete booking $id', resultDelete.error);
  //         return resultDelete;
  //     }
  //
  //     // After deleting the booking, we need to reload the bookings list.
  //     // BookingRepository is the source of truth for bookings.
  //     final resultLoadBookings = await _eventRepository.getBookingsList();
  //     switch (resultLoadBookings) {
  //       case Ok<List<BookingSummary>>():
  //         _bookings = resultLoadBookings.value;
  //         _log.fine('Loaded bookings');
  //       case Error<List<BookingSummary>>():
  //         _log.warning('Failed to load bookings', resultLoadBookings.error);
  //         return resultLoadBookings;
  //     }
  //
  //     return resultLoadBookings;
  //   } finally {
  //     notifyListeners();
  //   }
  // }
}

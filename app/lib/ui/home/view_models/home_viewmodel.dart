import 'package:flutter/material.dart';

import '../../../data/repositories/event/event_repository.dart';
import '../../../domain/models/event/category_colour.dart';
import '../../../domain/models/event/event.dart';
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

  Widget eventTile(Event singleEvent) => Card(
    color: singleEvent.category.colour,
    child: ListTile(
      leading: SelectableText(
        singleEvent.category.toString(),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      title: SelectableText('${singleEvent.id} - ${singleEvent.address}'),
      subtitle: SelectableText(singleEvent.status.toString()),
    ),
  );

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

// import 'package:flutter/material.dart';
// import 'package:logging/logging.dart';
//
// import '../../../data/repositories/event/event_repository.dart';
// import '../../../data/repositories/unit/unit_repository.dart';
// import '../../../domain/models/event/event.dart';
// import '../../../domain/models/unit/unit.dart';
// import '../../../utils/command.dart';
// import '../../../utils/result.dart';
//
// class MapViewModel extends ChangeNotifier {
//   MapViewModel({
//     required this._eventRepository,
//     required this._unitRepository,
//   }) {
//     load = Command0(_load)..execute();
//   }
//   Event? _event;
//
//   Event? get event => _event;
//
//   final EventRepository _eventRepository;
//
//   final UnitRepository _unitRepository;
//
//   late Command0 load;
//
//   Future<Result> _load() async {
//     try {
//       final result = await _eventRepository.selectedEvent;
//       switch (result) {
//         case Ok<Event?>():
//           _event = result.value;
//           _log.fine('Loaded event');
//           return Result.ok(_event);
//         case Error<Event?>():
//           _log.warning('Failed to load event', result.error);
//           return result;
//       }
//     } finally {
//       notifyListeners();
//     }
//   }
//
//   final Logger _log = Logger('MapViewModel');
//
//   GestureTapCallback setSelectedEvent(Event event) {
//     return () {
//       _eventRepository.setEvent(event);
//     };
//   }
//
//   Future<Result<List<Unit>>> get units => _unitRepository.allUnits;
// }

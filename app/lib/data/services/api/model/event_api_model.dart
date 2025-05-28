// import 'package:latlng/latlng.dart';
//
// import '../../../../domain/models/event/category.dart';
// import '../../../../domain/models/status.dart';
//
// // TODO consider deleting this file.
//
// /// An emergency event that the ambulance service has become aware of.
// class EventApiModel {
//   EventApiModel({
//     required this.id,
//     required this.address,
//     required this.status,
//     required List<String>? assignedCallsigns,
//   }) : category = status.category,
//        _assignedCallsigns = assignedCallsigns ?? List.empty(growable: true) {
//     if (status == EventStatus.preAlert()) {
//       assert(category == Category.none);
//     }
//
//     if (category == Category.none) {
//       assert(_noc == null);
//     }
//   }
//
//   /// The street address of the emergency.
//   String address;
//
//   final List<String> _assignedCallsigns;
//
//   // TODO keep this is sync with assignedUnits, converting assignedUnits to a getter that pulls Units from the server based on these callsigns.
//   /// The callsigns of the ambulances and other units assigned to this event.
//   List<String> get assignedCallsigns => _assignedCallsigns;
//
//   Category category;
//
//   /// A unique numerical identifier.
//   final int id;
//
//   /// The latitude and longitude of the emergency.
//   late LatLng location;
//
//   // /// Returns the latitude and longitude of a given street [address].
//   // Future<Location> _locationFromAddress() async {
//   //   GeocodingResponse info = await geocoding.searchByAddress(address);
//   //   GeocodingResult result = info.results[0];
//   //   Location location = result.geometry.location;
//   //
//   //   return location;
//   // }
//
//   /// Nature of Call.
//   NOC? _noc;
//
//   /// Nature of Call.
//   NOC? get noc => _noc;
//
//   EventStatus status;
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'status': status.toJson(),
//     'address': address,
//     'assignedCallsigns': assignedCallsigns,
//     // 'assignedUnits': assignedUnits,
//     // TODO remove assignedUnits map to get callsigns
//     // List<String>.from(
//     //   assignedUnits.map((Unit assignedUnit) => assignedUnit.callsign),
//     // ),
//   };
//
//   @override
//   String toString() => 'Event $id';
// }

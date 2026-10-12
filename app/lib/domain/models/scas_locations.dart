import 'dart:collection';

import 'package:latlong2/latlong.dart';

final class SCASLocation {
  const SCASLocation(this.name, this.latlng);

  final LatLng latlng;

  final String name;
}

/// Where ambulances are based.
enum AmbulanceStation implements SCASLocation {
  // NEOCN
  miltonKeynesBLH('Blue Light Hub', LatLng(52.013698, -0.736235), Node.neocn),
  stoke(
    'Stoke Mandeville RC',
    LatLng(51.79634209047873, -0.8041245499532154),
    Node.neocn,
  ),

  // NEOCE
  highWycombe(
    'High Wycombe Ambulance Station',
    LatLng(51.628806389618696, -0.7620403161215689),
    Node.neoce,
  ),
  wexham(
    'Wexham Park RC',
    LatLng(51.53025332371279, -0.5726914939841762),
    Node.neoce,
  ),

  // NEOCS
  bracknelll(
    'Bracknell RC',
    LatLng(51.411535031387125, -0.7555603250923306),
    Node.neocs,
  ),
  newbury(
    'Newbury RC',
    LatLng(51.40767976359783, -1.318461556338926),
    Node.neocs,
  ),
  reading(
    'Reading RC',
    LatLng(51.45786457143275, -0.9805779193963281),
    Node.neocs,
  ),

  // NEOCW
  adderbury(
    'Adderbury RC',
    LatLng(52.01338102535527, -1.2909053202697969),
    Node.neocw,
  ),
  didcot(
    'Didcot RC',
    LatLng(51.606605585534076, -1.246999906229091),
    Node.neocw,
  ),
  kidlington(
    'Kidlington Ambulance Station',
    LatLng(51.82967533742798, -1.3131410268822319),
    Node.neocw,
  ),
  oxfordCity(
    'Oxford City RC',
    LatLng(51.75095504438895, -1.2122845720873812),
    Node.neocw,
  ),

  // SEOCN
  alton(
    'Alton ARC',
    LatLng(51.15371573885096, -0.9632952391351366),
    Node.seocn,
  ),
  andover(
    'Andover ARC',
    LatLng(51.21675603548502, -1.4963301092567776),
    Node.seocn,
  ),
  basingstoke(
    'Basingstoke ARC',
    LatLng(51.28458101811476, -1.1122385571130877),
    Node.seocn,
  ),
  winchesterEastleigh(
    'Winchester & Eastleigh RC (WERC)',
    LatLng(50.97567122774519, -1.3701626880398503),
    Node.seocn,
  ),
  whitchurch(
    'Whitchurch ARC',
    LatLng(51.23478813021938, -1.3414490153314083),
    Node.seocn,
  ),

  // SEOCE
  northHarbour(
    'North Harbour Resource Centre',
    LatLng(50.84391499376645, -1.079225286886599),
    Node.seoce,
  ),
  petersfield(
    'Petersfield ARC',
    LatLng(51.00774241528381, -0.9299311466340103),
    Node.seoce,
  ),

  // SEOCW
  hightown(
    'Hightown ARC',
    LatLng(50.90037885839924, -1.3264801722359623),
    Node.seocw,
  ),
  hythe(
    'Hythe ARC',
    LatLng(50.859182104474165, -1.4023315488950747),
    Node.seocw,
  ),
  lymington(
    'Lymington ARC',
    LatLng(50.766145896265975, -1.5829421499995655),
    Node.seocw,
  ),
  nursling(
    'Nursling RC',
    LatLng(50.93934870882286, -1.474896484751043),
    Node.seocw,
  ),
  ringwood(
    'Ringwood ARC',
    LatLng(50.84959889053607, -1.7675444483238003),
    Node.seocw,
  );

  const AmbulanceStation(this.name, this.latlng, this.node);

  @override
  final LatLng latlng;

  @override
  final String name;

  final Node node;
}

/// SCAS's control centres.
enum EmergencyOperationsCentre implements SCASLocation {
  northernHouse(
    'Northern House',
    LatLng(51.89184192677591, -1.148360824928009),
  ),
  southernHouse(
    'Southern House',
    LatLng(51.00906817962309, -1.334545453928396),
  );

  const EmergencyOperationsCentre(this.name, this.latlng);

  @override
  final LatLng latlng;

  @override
  final String name;

  List<Node> get nodes => switch (this) {
    EmergencyOperationsCentre.northernHouse => Node.northernHouseNodes,
    EmergencyOperationsCentre.southernHouse => Node.southernHouseNodes,
  };
}

/// The different areas covered by SCAS.
enum Node {
  neocn,
  neoce,
  neocs,
  neocw,

  seocn,
  seoce,
  seocw;

  String get nameUpper => name.toUpperCase();

  static List<Node> get northernHouseNodes =>
      UnmodifiableListView([Node.neocn, Node.neoce, Node.neocs, Node.neocw]);

  static List<Node> get southernHouseNodes =>
      UnmodifiableListView([Node.seocn, Node.seoce, Node.seocw]);
}

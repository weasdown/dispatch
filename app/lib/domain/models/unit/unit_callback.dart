import '../../../../domain/models/unit/unit.dart';
import '../../../data/defaults.dart';

abstract class UnitCallback {
  UnitCallback();

  Unit call();
}

class UnitCallsignCallback extends UnitCallback {
  UnitCallsignCallback(String callsign) : _callsign = callsign;

  final String _callsign;

  @override
  Unit call() =>
      Defaults.units.where((Unit unit) => unit.callsign == _callsign).first;
}

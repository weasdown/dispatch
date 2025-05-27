import '../../../../domain/models/unit/unit.dart';
import '../../../data/repositories/unit/unit_repository.dart';
import '../../../utils/result.dart';

abstract class UnitCallback {
  UnitCallback();

  Future<Unit> call(UnitRepository unitRepository);
}

class UnitCallsignCallback extends UnitCallback {
  UnitCallsignCallback(String callsign) : _callsign = callsign;

  final String _callsign;

  @override
  Future<Unit> call(UnitRepository unitRepository) async =>
      (await unitRepository.allUnits as Ok<List<Unit>>).value
          .where((Unit unit) => unit.callsign == _callsign)
          .first;
}

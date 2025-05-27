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
  Future<Unit> call(UnitRepository unitRepository) async {
    Result<List<Unit>> unitsResult = await unitRepository.allUnits;

    return switch (unitsResult) {
      Ok<List<Unit>>() =>
        unitsResult.value
            .where((Unit unit) => unit.callsign == _callsign)
            .first,
      Error<List<Unit>>() => Future.error(unitsResult.error),
    };
  }
}

extension FromCallback on Unit {
  /// Gets a [Unit] from the server's list of [Unit]s based on its [Unit.callsign].
  static Future<Unit> fromCallsignCallback(
    UnitRepository unitRepository,
    String callsign,
  ) async => await UnitCallsignCallback(callsign).call(unitRepository);
}

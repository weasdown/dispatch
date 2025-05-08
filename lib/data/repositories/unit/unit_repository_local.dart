import '../../../domain/models/unit.dart';
import '../../../utils/result.dart';
import '../../services/local_data_service.dart';
import 'unit_repository.dart';

/// Local implementation of EventRepository
class UnitRepositoryLocal implements UnitRepository {
  UnitRepositoryLocal({required LocalDataService localDataService})
    : _localDataService = localDataService;

  final _units = List<Unit>.empty(growable: true);
  final LocalDataService _localDataService;

  @override
  Future<Result<List<Unit>>> get allUnits {
    List<Unit> units = _localDataService.units;
    _units.addAll(units);
    return Future(() => Result.ok(units));
  }

  @override
  Future<Result<Unit>> unitByCallsign(String callsign) async {
    Unit? unit =
        _localDataService.units
            .where((Unit unit) => unit.callsign == callsign)
            .firstOrNull;

    return switch (unit) {
      Unit _ => Future(() => Result<Unit>.ok(unit)),
      null => Future(
        () => Result<Unit>.error(
          Exception('Unit not found for callsign $callsign.'),
        ),
      ),
    };
  }
}

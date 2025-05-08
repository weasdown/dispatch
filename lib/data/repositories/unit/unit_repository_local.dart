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
  Future<Result<Unit>> unitByCallsign(String callsign) {
    // TODO: implement unitByCallsign
    throw UnimplementedError();
  }
}

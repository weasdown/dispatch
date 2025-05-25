import '../../../domain/models/unit/unit.dart';
import '../../../utils/result.dart';
import '../../services/api/units_api_client.dart';
import '../../services/local_data_service.dart';

/// Data source for units.
abstract class UnitRepository {
  /// Get activities by [Destination] ref.
  Future<Result<List<Unit>>> getUnits();
}

/// Local implementation of UnitRepository
/// Uses data from assets folder
class UnitRepositoryLocal implements UnitRepository {
  UnitRepositoryLocal({required LocalDataService localDataService})
    : _localDataService = localDataService;

  final LocalDataService _localDataService;

  @override
  Future<Result<List<Unit>>> getUnits() =>
      Future(() => Result.ok(_localDataService.units));
}

/// Remote data source for [Unit].
///
/// Implements basic local caching.
/// See: https://docs.flutter.dev/get-started/fwe/local-caching
class UnitRepositoryRemote implements UnitRepository {
  UnitRepositoryRemote({required UnitsApiClient apiClient})
    : _apiClient = apiClient;

  final UnitsApiClient _apiClient;

  final List<Unit> _cachedData = [];

  @override
  Future<Result<List<Unit>>> getUnits() async {
    Future<Result<List<Unit>>> unitsFuture = _apiClient.getUnits();
    Result<List<Unit>> unitsResult = await unitsFuture;

    switch (unitsResult) {
      case Ok<List<Unit>> _:
        _cachedData.addAll(unitsResult.value);
        return unitsFuture;

      case Error<List<Unit>> _:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}

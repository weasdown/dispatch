import '../services/api/api_client.dart';
import '../services/local_data_service.dart';

/// A generic data source.
abstract class Repository {}

/// A repository that gets its data from a [LocalDataService].
mixin LocalRepository on Repository {
  LocalDataService get localDataService;
}

/// A repository that gets its data from a remote API.
mixin RemoteRepository on Repository {
  ApiClient get apiClient;
}

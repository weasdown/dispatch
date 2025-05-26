import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/auth/auth_repository.dart';
import '../data/repositories/auth/auth_repository_dev.dart';
import '../data/repositories/event/event_repository.dart';
import '../data/repositories/event/event_repository_local.dart';
import '../data/services/api/api_client.dart';
import '../data/services/local_data_service.dart';

/// Shared providers for all configurations.
List<SingleChildWidget> _sharedProviders = [
  // Remove dev provider.
  ChangeNotifierProvider.value(value: AuthRepositoryDev() as AuthRepository),
];

/// Configure dependencies for local data.
/// This dependency list uses repositories that provide local data.
/// The user is always logged in.
List<SingleChildWidget> get providersLocal {
  return [
    Provider.value(value: LocalDataService()),
    Provider(
      create: (context) =>
          EventRepositoryLocal(localDataService: context.read())
              as EventRepository,
    ),
  ];
}

/// Configure dependencies for remote data.
/// This dependency list uses repositories that connect to a remote server.
List<SingleChildWidget> get providersRemote {
  return [Provider(create: (context) => ApiClient()), ..._sharedProviders];
}

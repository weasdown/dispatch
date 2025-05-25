import '../../../domain/models/unit/unit.dart';
import '../../../utils/result.dart';

class UnitsApiClient {
  UnitsApiClient();

  /// Returns a list of all the [Unit]s that are currently signed in.
  Future<Result<List<Unit>>> getUnits() async {
    // TODO replace placeholderUnits with logic that requests the list from the server then parses it to a List<Unit>. Include error handling that returns a Future<Error<List<Unit>>>.
    List<Unit> placeholderUnits = [];

    // // Handle an invalid server response.
    // return Future(() => Result.error(http.ClientException('Invalid response')));

    return Future(() => Result.ok(placeholderUnits));
  }
}

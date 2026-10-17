import '../../../domain/models/person/user.dart';
import '../../../utils/result.dart';

/// Source for user data.
abstract class UserRepository {
  /// Get current user
  Future<Result<User>> getUser();
}

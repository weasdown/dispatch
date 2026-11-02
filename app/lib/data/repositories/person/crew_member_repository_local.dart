import '../../../domain/models/person/crew_member.dart';
import '../../../utils/result.dart';
import '../../services/local_data_service.dart';
import 'crew_member_repository.dart';

/// Local implementation of UnitRepository
class CrewMemberRepositoryLocal extends CrewMemberRepository {
  CrewMemberRepositoryLocal({required this._localDataService});

  @override
  Future<Result<List<CrewMember>>> get allCrewMembers async {
    // Initialize the repository with default crew members.
    if (!_isInitialized) {
      _crewMembers.addAll(_localDataService.crewMembers);
      _isInitialized = true;
    }

    return Result.ok(_crewMembers);
  }

  final _crewMembers = List<CrewMember>.empty(growable: true);

  @override
  Future<Result<CrewMember>> crewMemberByESR({required ESR esr}) {
    // TODO: implement crewMemberByESR
    throw UnimplementedError();
  }

  // Only create default crew members once.
  bool _isInitialized = false;

  final LocalDataService _localDataService;
}

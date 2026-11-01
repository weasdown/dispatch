import '../../../domain/models/person/crew_member.dart';
import '../../../utils/result.dart';

/// Source for crew member data.
abstract class CrewMemberRepository {
  const CrewMemberRepository();

  Future<Result<List<CrewMember>>> get allCrewMembers;

  /// Get a crew member by their ESR.
  Future<Result<CrewMember>> crewMemberByESR({required ESR esr});
}

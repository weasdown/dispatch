import '../../../domain/models/person/patient.dart';
import '../../../utils/result.dart';
import '../../services/local_data_service.dart';
import 'patient_repository.dart';

/// Source for patient data.
class PatientRepositoryLocal implements PatientRepository {
  const PatientRepositoryLocal({required this._localDataService});

  final LocalDataService _localDataService;

  /// Get a patient by their UUID.
  @override
  Future<Result<Patient>> getPatient() async =>
      Result.ok(_localDataService.getPatient());
}

import '../../../domain/models/person/patient.dart';
import '../../../utils/result.dart';

/// Source for patient data.
abstract class PatientRepository {
  /// Get a patient by their UUID.
  Future<Result<Patient>> getPatient();
}

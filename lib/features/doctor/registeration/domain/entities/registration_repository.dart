import '../doctor_registration_entity.dart';

abstract class RegistrationRepository {
  Future<void> registerDoctor(DoctorRegistrationEntity registrationData);
}

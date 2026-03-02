import 'package:doctor_booking_app/features/doctor/auth/domain/repositories/doctor_auth_repository.dart';

class DoctorSignUp {
  final DoctorAuthRepository repository;

  const DoctorSignUp(this.repository);

  Future<void> call(String email, String password) {
    return repository.signUp(email, password);
  }
}

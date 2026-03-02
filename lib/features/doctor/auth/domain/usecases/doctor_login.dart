import 'package:doctor_booking_app/features/doctor/auth/domain/repositories/doctor_auth_repository.dart';

class DoctorLogin {
  final DoctorAuthRepository repository;

  const DoctorLogin(this.repository);

  Future<void> call(String email, String password) {
    return repository.login(email, password);
  }
}
import 'package:doctor_booking_app/features/doctor/auth/domain/repositories/doctor_auth_repository.dart';

class DoctorIsLoggedIn {
  final DoctorAuthRepository repository;

  DoctorIsLoggedIn(this.repository);

  Future<bool> call() {
    return repository.isLoggedIn();
  }
}
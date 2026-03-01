import 'package:doctor_booking_app/features/doctor/auth/domain/repositories/doctor_auth_repository.dart';

class DoctorSignOut {
  final DoctorAuthRepository repository;

  DoctorSignOut(this.repository);

  Future<void> call() {
    return repository.signOut();
  }
}
import 'package:doctor_booking_app/features/doctor/auth/domain/entities/doctor_entity.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/repositories/doctor_auth_repository.dart';

class GetCurrentDoctor {
  final DoctorAuthRepository repository;

  GetCurrentDoctor(this.repository);

  Future<DoctorEntity?> call() {
    return repository.getCurrentUser();
  }
}
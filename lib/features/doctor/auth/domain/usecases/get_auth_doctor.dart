import 'package:doctor_booking_app/features/doctor/auth/domain/entities/doctor_entity.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/repositories/doctor_auth_repository.dart';

class GetAuthDoctor {
  final DoctorAuthRepository repository;

  const GetAuthDoctor(this.repository);

  Future<DoctorAuthEntity?> call() {
    return repository.getAuthDoctor();
  }
}
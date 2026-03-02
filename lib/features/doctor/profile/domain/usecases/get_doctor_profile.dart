import 'package:doctor_booking_app/features/doctor/registeration/domain/entities/doctor_registration_entity.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/repositories/doctor_repositories.dart';

class GetDoctorProfile {
  final DoctorRepository repository;

  GetDoctorProfile(this.repository);

  Future<DoctorRegistrationEntity?> call(String id) {
    return repository.getDoctorById(id);
  }
}

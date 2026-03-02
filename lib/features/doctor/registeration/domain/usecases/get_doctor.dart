import 'package:doctor_booking_app/features/doctor/registeration/domain/entities/doctor_registration_entity.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/repositories/doctor_repositories.dart';

class GetDoctor {
  final DoctorRepository repository;

  GetDoctor(this.repository);

  Future<List<DoctorRegistrationEntity>> call() {
    return repository.getDoctors();
  }
}

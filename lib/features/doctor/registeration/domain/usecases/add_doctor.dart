import 'package:doctor_booking_app/features/doctor/registeration/domain/entities/doctor_registration_entity.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/repositories/doctor_repositories.dart';

class AddDoctor {
  final DoctorRepository repository;

  AddDoctor(this.repository);

  Future<void> call(DoctorRegistrationEntity doctor) {
    return repository.addDoctor(doctor);
  }
}
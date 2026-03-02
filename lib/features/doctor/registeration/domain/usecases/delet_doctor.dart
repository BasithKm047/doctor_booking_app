import 'package:doctor_booking_app/features/doctor/registeration/domain/repositories/doctor_repositories.dart';

class DeleteDoctor {
  final DoctorRepository repository;

  DeleteDoctor(this.repository);

  Future<void> call(String id) {
    return repository.deleteDoctor(id);
  }
}
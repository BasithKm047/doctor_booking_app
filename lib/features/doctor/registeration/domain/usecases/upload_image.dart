import 'package:doctor_booking_app/features/doctor/registeration/domain/repositories/doctor_repositories.dart';

class UploadImage {
  final DoctorRepository repository;

  UploadImage(this.repository);

  Future<String?> call(String path) {
    return repository.uploadImage(path);
  }
}

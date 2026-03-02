import 'package:doctor_booking_app/features/doctor/registeration/domain/entities/doctor_registration_entity.dart';

abstract class DoctorRepository {
  Future<void> addDoctor(DoctorRegistrationEntity doctor);
  Future<void> updateDoctor(DoctorRegistrationEntity doctor);
  Future<List<DoctorRegistrationEntity>> getDoctors();
  Future<DoctorRegistrationEntity?> getDoctorById(String id);
  Future<void> deleteDoctor(String id);
  Future<String?> uploadImage(String path);
}

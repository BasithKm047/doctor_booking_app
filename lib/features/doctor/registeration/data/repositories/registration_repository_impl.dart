import 'package:doctor_booking_app/features/doctor/registeration/data/model/doctor_model.dart'
    show DoctorModel;
import 'package:doctor_booking_app/features/doctor/registeration/domain/entities/doctor_registration_entity.dart';
import 'package:doctor_booking_app/features/doctor/registeration/data/data_source/doctor_remote_data_source.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/entities/doctor_registration_entity.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/repositories/doctor_repositories.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource remote;

  DoctorRepositoryImpl(this.remote);

  @override
  Future<void> addDoctor(DoctorRegistrationEntity doctor) {
    return remote.addDoctor(
      DoctorModel(
        id: doctor.id,
        name: doctor.name,
        profileImage: doctor.profileImage,
        specialization: doctor.specialization,
        experience: doctor.experience,
        consultationFee: doctor.consultationFee,
        bio: doctor.bio,
      ),
    );
  }

  @override
  Future<void> updateDoctor(DoctorRegistrationEntity doctor) {
    return remote.updateDoctor(
      DoctorModel(
        id: doctor.id,
        name: doctor.name,
        profileImage: doctor.profileImage,
        specialization: doctor.specialization,
        experience: doctor.experience,
        consultationFee: doctor.consultationFee,
        bio: doctor.bio,
      ),
    );
  }

  @override
  Future<DoctorRegistrationEntity?> getDoctorById(String id) async {
    final doctor = await remote.getDoctorById(id);
    if (doctor == null) return null;
    return DoctorRegistrationEntity(
      id: doctor.id,
      name: doctor.name,
      profileImage: doctor.profileImage,
      specialization: doctor.specialization,
      experience: doctor.experience,
      consultationFee: doctor.consultationFee,
      bio: doctor.bio,
    );
  }

  @override
  Future<List<DoctorRegistrationEntity>> getDoctors() {
    return remote.getDoctors();
  }

  @override
  Future<void> deleteDoctor(String id) {
    return remote.deleteDoctor(id);
  }

  @override
  Future<String?> uploadImage(String path) {
    return remote.uploadImage(path);
  }
}

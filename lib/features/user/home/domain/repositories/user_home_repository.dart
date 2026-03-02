import '../entities/user_doctor_entity.dart';

abstract class UserHomeRepository {
  Future<List<UserDoctorEntity>> getDoctors();
}

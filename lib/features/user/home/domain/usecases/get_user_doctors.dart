import '../entities/user_doctor_entity.dart';
import '../repositories/user_home_repository.dart';

class GetUserDoctors {
  final UserHomeRepository repository;

  GetUserDoctors(this.repository);

  Future<List<UserDoctorEntity>> call() async {
    return await repository.getDoctors();
  }
}

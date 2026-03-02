import '../../domain/entities/user_doctor_entity.dart';
import '../../domain/repositories/user_home_repository.dart';
import '../datasources/user_home_remote_data_source.dart';

class UserHomeRepositoryImpl implements UserHomeRepository {
  final UserHomeRemoteDataSource remoteDataSource;

  UserHomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<UserDoctorEntity>> getDoctors() async {
    return await remoteDataSource.getDoctors();
  }
}

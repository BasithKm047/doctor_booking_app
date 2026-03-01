import 'package:doctor_booking_app/features/user/auth/data/data_source/auth_remote_data_source.dart';
import 'package:doctor_booking_app/features/user/auth/domain/entities/user_entitt.dart';
import 'package:doctor_booking_app/features/user/auth/domain/repositories/auth_repositories.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  AuthRepositoryImpl(this.remote);

  @override
  Future<void> sentOtp(String phone) => remote.sentOtp(phone);

  @override
  Future<UserEntity> verifyOtp(String phone, String otp) async {
    final model = await remote.verifyOtp(phone, otp);
    return UserEntity(id: model.id, role: model.role, phone: model.phone);
  }

  @override
  Future<bool> isLoggedIn() async {
    return remote.isLoggedIn();
  }

  @override
  Future<void> signOut() async {  
    await remote.signOut();
  }
}

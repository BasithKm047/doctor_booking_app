import 'package:doctor_booking_app/core/service/client.dart';
import 'package:doctor_booking_app/features/doctor/auth/data/data_source/doctor_auth_remote_data_source.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/entities/doctor_entity.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/repositories/doctor_auth_repository.dart';

class DoctorAuthRepositoryImpl implements DoctorAuthRepository {
  final DoctorAuthRemoteDataSource remote;

  DoctorAuthRepositoryImpl(this.remote);

 
  @override
  Future<void> sendMagicLink(String email) {
    return remote.sendMagicLink(email);
  }

  @override
  Future<DoctorEntity?> getCurrentUser() {
    return remote.getCurrentUserProfile();
  }
  @override
  Future<void> signOut() {
    return remote.signOut();
  }

@override
Future<bool> isLoggedIn() async {
  return supabase.auth.currentUser != null;
}
}

import 'package:doctor_booking_app/core/service/app_logger.dart';
import 'package:doctor_booking_app/core/service/client.dart';
import 'package:doctor_booking_app/features/doctor/auth/data/data_source/doctor_auth_remote_data_source.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/entities/doctor_entity.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/repositories/doctor_auth_repository.dart';

class DoctorAuthRepositoryImpl implements DoctorAuthRepository {
  final DoctorAuthRemoteDataSource remote;

  DoctorAuthRepositoryImpl(this.remote);

  @override
  Future<void> login(String email, String password) {
    AppLogger.info('Repository: Logging in doctor $email');
    return remote.login(email, password);
  }

  @override
  Future<void> signUp(String email, String password) {
    AppLogger.info('Repository: Signing up doctor $email');
    return remote.signUp(email, password);
  }

  @override
  Future<void> signOut() {
    AppLogger.info('Repository: Signing out');
    return remote.signOut();
  }

  @override
  Future<DoctorAuthEntity?> getAuthDoctor() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;
    return DoctorAuthEntity(id: user.id, email: user.email!, role: 'doctor');
  }

  @override
  Future<bool> isLoggedIn() async {
    final status = supabase.auth.currentUser != null;
    AppLogger.debug(
      'Repository: Check auth status: ${status ? "Logged In" : "Not Logged In"}',
    );
    return status;
  }
}

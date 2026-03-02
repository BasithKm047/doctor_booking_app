import 'package:doctor_booking_app/features/doctor/auth/domain/entities/doctor_entity.dart';

abstract class DoctorAuthRepository {
  Future<void> login(String email, String password);
  Future<void> signUp(String email, String password);
  Future<DoctorAuthEntity?> getAuthDoctor();
  Future<void> signOut();
  Future<bool> isLoggedIn();
}

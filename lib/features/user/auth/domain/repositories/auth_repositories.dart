import 'package:doctor_booking_app/features/user/auth/domain/entities/user_entitt.dart';

abstract class AuthRepository {
  Future<void> sentOtp(String phone);
  Future<UserEntity> verifyOtp(String phone, String otp);
  Future<bool> isLoggedIn();
  Future<void> signOut();
}

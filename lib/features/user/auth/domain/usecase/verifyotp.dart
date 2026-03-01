import 'package:doctor_booking_app/features/user/auth/domain/entities/user_entitt.dart';
import 'package:doctor_booking_app/features/user/auth/domain/repositories/auth_repositories.dart';

class VerifyOtp {
  final AuthRepository repository;

  VerifyOtp(this.repository);

  Future<UserEntity> call(String phone, String otp) {
    return repository.verifyOtp(phone, otp);
  }
}
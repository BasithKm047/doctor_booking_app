import 'package:doctor_booking_app/features/user/auth/domain/repositories/auth_repositories.dart';

class SendOtp {
  final AuthRepository repository;

  SendOtp(this.repository);

  Future<void> call(String phone) {
    return repository.sentOtp(phone);
  }
}
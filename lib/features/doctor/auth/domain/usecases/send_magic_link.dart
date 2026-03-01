import 'package:doctor_booking_app/features/doctor/auth/domain/repositories/doctor_auth_repository.dart';

class SendMagicLink {
  final DoctorAuthRepository repository;

  SendMagicLink(this.repository);

  Future<void> call(String email) {
    return repository.sendMagicLink(email);
  }
}
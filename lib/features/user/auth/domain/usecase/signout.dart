import 'package:doctor_booking_app/features/user/auth/domain/repositories/auth_repositories.dart';

class Signout {
  AuthRepository repository;
  Signout(this.repository);
  Future<void> call() {
    return repository.signOut();
  }
}
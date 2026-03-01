import 'package:doctor_booking_app/features/user/auth/domain/repositories/auth_repositories.dart';

class IsLoggedIn {
  final AuthRepository repository;

  IsLoggedIn(this.repository);

  Future<bool> call() {
    return repository.isLoggedIn();
  }
}
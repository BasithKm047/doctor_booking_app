import 'package:doctor_booking_app/features/doctor/auth/domain/entities/doctor_entity.dart';

abstract class DoctorAuthRepository {
  Future<void> sendMagicLink(String email);
  Future<DoctorEntity?> getCurrentUser();
  Future<void> signOut();
   Future<bool> isLoggedIn();

}

import 'package:doctor_booking_app/features/user/appointment/domain/entities/user_appointment_entity.dart';
import 'package:doctor_booking_app/features/user/appointment/domain/repositories/user_appointment_repository.dart';

class BookAppointmentUseCase {
  final UserAppointmentRepository repository;

  BookAppointmentUseCase({required this.repository});

  Future<void> call(UserAppointmentEntity appointment) async {
    return await repository.bookAppointment(appointment);
  }
}

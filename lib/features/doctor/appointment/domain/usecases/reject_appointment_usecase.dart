import 'package:doctor_booking_app/features/doctor/appointment/domain/repositories/doctor_appointment_repository.dart';

class RejectAppointmentUseCase {
  final DoctorAppointmentRepository repository;

  RejectAppointmentUseCase(this.repository);

  Future<void> call(String appointmentId) async {
    return await repository.rejectAppointment(appointmentId);
  }
}

import 'package:doctor_booking_app/features/doctor/appointment/domain/repositories/doctor_appointment_repository.dart';

class AcceptAppointmentUseCase {
  final DoctorAppointmentRepository repository;

  AcceptAppointmentUseCase(this.repository);

  Future<void> call(String appointmentId) async {
    return await repository.acceptAppointment(appointmentId);
  }
}

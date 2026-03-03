import 'package:doctor_booking_app/features/doctor/appointment/domain/entities/appointment_request_entity.dart';
import 'package:doctor_booking_app/features/doctor/appointment/domain/repositories/doctor_appointment_repository.dart';

class GetDoctorAppointmentsUseCase {
  final DoctorAppointmentRepository repository;

  GetDoctorAppointmentsUseCase(this.repository);

  Future<List<AppointmentRequest>> call(String doctorId) async {
    return await repository.getDoctorAppointments(doctorId);
  }
}

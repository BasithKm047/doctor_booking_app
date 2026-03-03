import 'package:doctor_booking_app/features/doctor/appointment/domain/entities/appointment_request_entity.dart';

abstract class DoctorAppointmentRepository {
  Future<List<AppointmentRequest>> getDoctorAppointments(String doctorId);
  Future<void> acceptAppointment(String appointmentId);
  Future<void> rejectAppointment(String appointmentId);
}

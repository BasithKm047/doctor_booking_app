import 'package:doctor_booking_app/features/user/appointment/domain/entities/user_appointment_entity.dart';

abstract class UserAppointmentRepository {
  Future<List<Map<String, dynamic>>> fetchDoctorAvailability(String doctorId);
  Future<List<Map<String, dynamic>>> fetchUserAppointments(String userId);
  Future<void> bookAppointment(UserAppointmentEntity appointment);
  Future<void> cancelAppointment(String appointmentId);
  Future<void> rescheduleAppointment({
    required String appointmentId,
    required String appointmentDate,
    required String appointmentTime,
  });
}

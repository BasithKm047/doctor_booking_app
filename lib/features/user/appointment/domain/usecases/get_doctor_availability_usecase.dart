import 'package:doctor_booking_app/features/user/appointment/domain/repositories/user_appointment_repository.dart';

class GetDoctorAvailabilityUseCase {
  final UserAppointmentRepository repository;

  GetDoctorAvailabilityUseCase({required this.repository});

  Future<List<Map<String, dynamic>>> call(String doctorId) async {
    return await repository.fetchDoctorAvailability(doctorId);
  }
}

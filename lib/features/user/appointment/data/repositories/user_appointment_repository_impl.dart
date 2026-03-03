import 'package:doctor_booking_app/features/user/appointment/data/datasources/user_appointment_remote_data_source.dart';
import 'package:doctor_booking_app/features/user/appointment/domain/entities/user_appointment_entity.dart';
import 'package:doctor_booking_app/features/user/appointment/domain/repositories/user_appointment_repository.dart';

class UserAppointmentRepositoryImpl implements UserAppointmentRepository {
  final UserAppointmentRemoteDataSource remoteDataSource;

  UserAppointmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Map<String, dynamic>>> fetchDoctorAvailability(
    String doctorId,
  ) async {
    return await remoteDataSource.fetchDoctorAvailability(doctorId);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchUserAppointments(
    String userId,
  ) async {
    return await remoteDataSource.fetchUserAppointments(userId);
  }

  @override
  Future<void> bookAppointment(UserAppointmentEntity appointment) async {
    return await remoteDataSource.bookAppointment(appointment);
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    return await remoteDataSource.cancelAppointment(appointmentId);
  }

  @override
  Future<void> rescheduleAppointment({
    required String appointmentId,
    required String appointmentDate,
    required String appointmentTime,
  }) async {
    return await remoteDataSource.rescheduleAppointment(
      appointmentId: appointmentId,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
    );
  }
}

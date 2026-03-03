import 'package:doctor_booking_app/features/doctor/appointment/data/datasources/doctor_appointment_remote_data_source.dart';
import 'package:doctor_booking_app/features/doctor/appointment/domain/entities/appointment_request_entity.dart';
import 'package:doctor_booking_app/features/doctor/appointment/domain/repositories/doctor_appointment_repository.dart';

class DoctorAppointmentRepositoryImpl implements DoctorAppointmentRepository {
  final DoctorAppointmentRemoteDataSource remoteDataSource;

  DoctorAppointmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AppointmentRequest>> getDoctorAppointments(
    String doctorId,
  ) async {
    return await remoteDataSource.getDoctorAppointments(doctorId);
  }

  @override
  Future<void> acceptAppointment(String appointmentId) async {
    return await remoteDataSource.acceptAppointment(appointmentId);
  }

  @override
  Future<void> rejectAppointment(String appointmentId) async {
    return await remoteDataSource.rejectAppointment(appointmentId);
  }
}

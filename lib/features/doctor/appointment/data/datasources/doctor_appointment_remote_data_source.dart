import 'package:doctor_booking_app/core/service/app_logger.dart';
import 'package:doctor_booking_app/features/doctor/appointment/domain/entities/appointment_request_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DoctorAppointmentRemoteDataSource {
  Future<List<AppointmentRequest>> getDoctorAppointments(String doctorId);
  Future<void> acceptAppointment(String appointmentId);
  Future<void> rejectAppointment(String appointmentId);
}

class DoctorAppointmentRemoteDataSourceImpl
    implements DoctorAppointmentRemoteDataSource {
  final SupabaseClient supabaseClient;

  DoctorAppointmentRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<AppointmentRequest>> getDoctorAppointments(
    String doctorId,
  ) async {
    try {
      final response = await supabaseClient
          .from('appointments')
          .select()
          .eq('doctor_id', doctorId)
          .order('appointment_date', ascending: true);

      return (response as List).map((data) {
        final statusText = (data['status'] ?? '')
            .toString()
            .trim()
            .toLowerCase();

        return AppointmentRequest(
          id: data['id'].toString(),
          patientName: data['patient_name'] ?? 'Unknown',
          patientId: data['user_id'].toString(),
          patientImageUrl: data['patient_image'],
          appointmentTime: DateTime.parse(
            '${data['appointment_date']} ${data['appointment_time']}',
          ),
          appointmentType: 'General Consultation',
          note: data['description'],
          isNew: true,
          status: statusText == 'confirmed'
              ? AppointmentStatus.confirmed
              : statusText == 'past'
              ? AppointmentStatus.past
              : AppointmentStatus.pending,
        );
      }).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching doctor appointments', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> acceptAppointment(String appointmentId) async {
    try {
      await supabaseClient
          .from('appointments')
          .update({
            'status': 'confirmed',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', appointmentId);
      AppLogger.info('Successfully accepted appointment $appointmentId');
    } catch (e, stackTrace) {
      AppLogger.error('Error accepting appointment', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> rejectAppointment(String appointmentId) async {
    try {
      await supabaseClient
          .from('appointments')
          .delete()
          .eq('id', appointmentId);
      AppLogger.info(
        'Successfully rejected/deleted appointment $appointmentId',
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error rejecting appointment', e, stackTrace);
      rethrow;
    }
  }
}

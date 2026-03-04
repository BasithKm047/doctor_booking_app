import 'package:doctor_booking_app/core/service/app_logger.dart';
import 'package:doctor_booking_app/features/user/appointment/domain/entities/user_appointment_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

abstract class UserAppointmentRemoteDataSource {
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

class UserAppointmentRemoteDataSourceImpl
    implements UserAppointmentRemoteDataSource {
  final SupabaseClient supabaseClient;

  UserAppointmentRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<Map<String, dynamic>>> fetchDoctorAvailability(
    String doctorId,
  ) async {
    try {
      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final response = await supabaseClient
          .from('doctor_availability')
          .select('doctor_id, available_date, start_time, end_time')
          .eq('doctor_id', doctorId)
          .gte('available_date', todayStr)
          .order('available_date', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching availability for doctor $doctorId',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchUserAppointments(
    String userId,
  ) async {
    try {
      final response = await supabaseClient
          .from('appointments')
          .select(
            'id, doctor_id, appointment_date, appointment_time, status, created_at',
          )
          .eq('user_id', userId)
          .order('appointment_date', ascending: true);

      final appointments = List<Map<String, dynamic>>.from(response);
      if (appointments.isEmpty) return const [];

      final doctorIds = appointments
          .map((item) => item['doctor_id']?.toString())
          .whereType<String>()
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      Map<String, Map<String, dynamic>> doctorsById = {};
      if (doctorIds.isNotEmpty) {
        final doctorsResponse = await supabaseClient
            .from('doctors')
            .select('id, name, specialization, profile_image')
            .inFilter('id', doctorIds);

        doctorsById = {
          for (final doctor in List<Map<String, dynamic>>.from(doctorsResponse))
            doctor['id'].toString(): doctor,
        };
      }

      return appointments.map((item) {
        final doctorId = item['doctor_id']?.toString() ?? '';
        final doctor = doctorsById[doctorId];
        return {
          ...item,
          'doctor_name': doctor?['name'] ?? 'Doctor',
          'doctor_specialization': doctor?['specialization'] ?? 'Specialist',
          'doctor_image':
              doctor?['profile_image'] ?? 'assets/images/doctor_image_1.png',
        };
      }).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching user appointments', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> bookAppointment(UserAppointmentEntity appointment) async {
    try {
      final formattedDate = DateFormat(
        'yyyy-MM-dd',
      ).format(appointment.appointmentDate);

      final Map<String, dynamic> data = {
        'user_id': appointment.userId,
        'doctor_id': appointment.doctorId,
        'appointment_date': formattedDate,
        'appointment_time': appointment.appointmentTime,
        'description': appointment.description,
        'patient_name': appointment.patientName,
        'patient_image': appointment.patientImage,
        'location': appointment.location,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await supabaseClient.from('appointments').insert(data);
      AppLogger.info(
        'Successfully booked appointment for user ${appointment.userId} with doctor ${appointment.doctorId}',
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error booking appointment', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final before = await _getAppointmentById(appointmentId);
      if (before == null) {
        throw Exception('Appointment not found');
      }
      if ((before['user_id'] ?? '').toString() != userId) {
        throw Exception('You can only cancel your own appointment');
      }

      await supabaseClient
          .from('appointments')
          .update({
            'status': 'canceled',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', before['id']);

      final after = await _getAppointmentById(appointmentId);
      if (after == null || !_isCanceledStatus((after['status'] ?? '').toString())) {
        throw Exception(
          'Cancel failed. Please check Supabase RLS policy for appointments update.',
        );
      }
      AppLogger.info('Successfully cancelled appointment: $appointmentId');
    } catch (e, stackTrace) {
      AppLogger.error('Error cancelling appointment', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> rescheduleAppointment({
    required String appointmentId,
    required String appointmentDate,
    required String appointmentTime,
  }) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final before = await _getAppointmentById(appointmentId);
      if (before == null) {
        throw Exception('Appointment not found');
      }
      if ((before['user_id'] ?? '').toString() != userId) {
        throw Exception('You can only reschedule your own appointment');
      }

      await supabaseClient
          .from('appointments')
          .update({
            'appointment_date': appointmentDate,
            'appointment_time': appointmentTime,
            'status': 'pending',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', before['id']);

      final after = await _getAppointmentById(appointmentId);
      if (after == null) {
        throw Exception('Reschedule failed. Appointment was not found after update.');
      }

      final afterDate = (after['appointment_date'] ?? '').toString();
      final afterTime = (after['appointment_time'] ?? '').toString();
      final afterStatus = (after['status'] ?? '').toString().toLowerCase();
      final sameDate = afterDate.startsWith(appointmentDate);
      final sameTime = afterTime.startsWith(_timePrefix(appointmentTime));
      final isPending = afterStatus == 'pending';

      if (!sameDate || !sameTime || !isPending) {
        throw Exception(
          'Reschedule failed. Please check Supabase RLS policy for appointments update.',
        );
      }
      AppLogger.info('Successfully rescheduled appointment: $appointmentId');
    } catch (e, stackTrace) {
      AppLogger.error('Error rescheduling appointment', e, stackTrace);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> _getAppointmentById(String appointmentId) async {
    final rows = await supabaseClient
        .from('appointments')
        .select('id, user_id, status, appointment_date, appointment_time')
        .eq('id', appointmentId)
        .limit(1);

    final firstPass = List<Map<String, dynamic>>.from(rows);
    if (firstPass.isNotEmpty) {
      return firstPass.first;
    }

    final parsedInt = int.tryParse(appointmentId);
    if (parsedInt == null) {
      return null;
    }

    final intRows = await supabaseClient
        .from('appointments')
        .select('id, user_id, status, appointment_date, appointment_time')
        .eq('id', parsedInt)
        .limit(1);
    final secondPass = List<Map<String, dynamic>>.from(intRows);
    if (secondPass.isEmpty) {
      return null;
    }
    return secondPass.first;
  }

  bool _isCanceledStatus(String status) {
    final normalized = status.toLowerCase();
    return normalized == 'canceled' ||
        normalized == 'cancelled' ||
        normalized == 'user_canceled' ||
        normalized == 'user_cancelled';
  }

  String _timePrefix(String value) {
    final trimmed = value.trim();
    if (trimmed.length >= 5) {
      return trimmed.substring(0, 5);
    }
    return trimmed;
  }
}

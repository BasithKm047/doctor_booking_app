import 'package:doctor_booking_app/core/service/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentsRealtimeService {
  final SupabaseClient supabaseClient;

  AppointmentsRealtimeService({required this.supabaseClient});

  RealtimeChannel subscribeToUserAppointments({
    required String userId,
    required void Function(PostgresChangePayload payload) onChange,
  }) {
    final channel = supabaseClient
        .channel('public:appointments:user:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'appointments',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: onChange,
        )
        .subscribe((status, [error]) {
          AppLogger.info('User appointments realtime status: $status');
          if (error != null) {
            AppLogger.error('User appointments realtime error', error);
          }
        });

    return channel;
  }

  RealtimeChannel subscribeToDoctorAppointments({
    required String doctorId,
    required void Function(PostgresChangePayload payload) onChange,
  }) {
    final channel = supabaseClient
        .channel('public:appointments:doctor:$doctorId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'appointments',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'doctor_id',
            value: doctorId,
          ),
          callback: onChange,
        )
        .subscribe((status, [error]) {
          AppLogger.info('Doctor appointments realtime status: $status');
          if (error != null) {
            AppLogger.error('Doctor appointments realtime error', error);
          }
        });

    return channel;
  }

  void unsubscribe(RealtimeChannel? channel) {
    if (channel == null) return;
    supabaseClient.removeChannel(channel);
  }
}

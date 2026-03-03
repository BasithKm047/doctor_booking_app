import 'package:doctor_booking_app/core/service/app_logger.dart';
import 'package:doctor_booking_app/features/doctor/shedule/domain/entities/availability_day_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

abstract class ScheduleRemoteDataSource {
  Future<void> saveAvailability(List<AvailabilityDay> schedule);
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final SupabaseClient supabaseClient;

  ScheduleRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<void> saveAvailability(List<AvailabilityDay> schedule) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }
      final doctorId = user.id;

      AppLogger.info('Saving schedule for doctor: $doctorId');

      // 1. Delete future un-booked availability for this doctor (using clear approach for demonstration)
      // Only delete from today onwards
      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await supabaseClient
          .from('doctor_availability')
          .delete()
          .eq('doctor_id', doctorId)
          .gte('available_date', todayStr);

      AppLogger.info('Cleared existing future availability for doctor.');

      // 2. Generate dates for the next 30 days based on selected schedule
      final List<Map<String, dynamic>> availabilityToInsert = [];
      final now = DateTime.now();

      // Helper function to convert "09:00 AM" to "09:00:00"
      String formatTime(String time12h) {
        try {
          final tempDate = DateFormat("hh:mm a").parse(time12h);
          return DateFormat("HH:mm:ss").format(tempDate);
        } catch (e) {
          AppLogger.error('Time parsing error for $time12h', e);
          return "09:00:00"; // fallback
        }
      }

      for (int i = 0; i < 30; i++) {
        final currentDate = now.add(Duration(days: i));
        // getting weekday: 1 = Monday, 7 = Sunday
        // However, in our UI `dayName` starts with Monday. Let's map it.
        final weekdayName = DateFormat('EEEE').format(currentDate);

        // Find if this day is active in UI schedule
        final scheduleForDay = schedule.firstWhere(
          (element) =>
              element.dayName.toLowerCase() == weekdayName.toLowerCase(),
          orElse: () => const AvailabilityDay(
            dayName: '',
            shortDayName: '',
            isActive: false,
          ),
        );

        if (scheduleForDay.isActive) {
          final formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
          final startTime = formatTime(scheduleForDay.startTime);
          final endTime = formatTime(scheduleForDay.endTime);

          availabilityToInsert.add({
            'doctor_id': doctorId,
            'available_date': formattedDate,
            'start_time': startTime,
            'end_time': endTime,
          });
        }
      }

      // 3. Insert generated dates into Supabase
      if (availabilityToInsert.isNotEmpty) {
        AppLogger.info(
          'Inserting ${availabilityToInsert.length} availability slots.',
        );
        await supabaseClient
            .from('doctor_availability')
            .insert(availabilityToInsert);
        AppLogger.info('Successfully saved availability slots.');
      } else {
        AppLogger.info('No active days found, no slots to insert.');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error saving availability', e, stackTrace);
      rethrow;
    }
  }
}

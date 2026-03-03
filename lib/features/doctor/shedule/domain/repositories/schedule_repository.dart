import 'package:doctor_booking_app/features/doctor/shedule/domain/entities/availability_day_entity.dart';

abstract class ScheduleRepository {
  Future<void> saveAvailability(List<AvailabilityDay> schedule);
}

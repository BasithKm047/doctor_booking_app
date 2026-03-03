import 'package:doctor_booking_app/features/doctor/shedule/domain/entities/availability_day_entity.dart';
import '../repositories/schedule_repository.dart';

class SaveScheduleUseCase {
  final ScheduleRepository repository;

  SaveScheduleUseCase({required this.repository});

  Future<void> call(List<AvailabilityDay> schedule) async {
    return await repository.saveAvailability(schedule);
  }
}

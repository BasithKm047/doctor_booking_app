import 'package:doctor_booking_app/features/doctor/shedule/data/datasources/schedule_remote_data_source.dart';
import 'package:doctor_booking_app/features/doctor/shedule/domain/entities/availability_day_entity.dart';
import 'package:doctor_booking_app/features/doctor/shedule/domain/repositories/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  ScheduleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> saveAvailability(List<AvailabilityDay> schedule) async {
    return await remoteDataSource.saveAvailability(schedule);
  }
}

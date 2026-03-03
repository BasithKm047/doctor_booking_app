import 'package:equatable/equatable.dart';
import 'package:doctor_booking_app/features/doctor/shedule/domain/entities/availability_day_entity.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

class SaveScheduleEvent extends ScheduleEvent {
  final List<AvailabilityDay> schedule;

  const SaveScheduleEvent(this.schedule);

  @override
  List<Object> get props => [schedule];
}

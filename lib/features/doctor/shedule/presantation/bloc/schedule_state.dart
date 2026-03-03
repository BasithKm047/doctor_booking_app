import 'package:equatable/equatable.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleSuccess extends ScheduleState {}

class ScheduleFailure extends ScheduleState {
  final String error;

  const ScheduleFailure(this.error);

  @override
  List<Object> get props => [error];
}

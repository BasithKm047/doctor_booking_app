import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_booking_app/features/doctor/shedule/domain/usecases/save_schedule_usecase.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final SaveScheduleUseCase saveScheduleUseCase;

  ScheduleBloc({required this.saveScheduleUseCase}) : super(ScheduleInitial()) {
    on<SaveScheduleEvent>((event, emit) async {
      emit(ScheduleLoading());
      try {
        await saveScheduleUseCase(event.schedule);
        emit(ScheduleSuccess());
      } catch (e) {
        emit(ScheduleFailure(e.toString()));
      }
    });
  }
}

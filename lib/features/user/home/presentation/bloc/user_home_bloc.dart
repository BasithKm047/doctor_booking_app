import 'package:doctor_booking_app/features/user/home/domain/usecases/get_user_doctors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_home_event.dart';
import 'user_home_state.dart';

class UserHomeBloc extends Bloc<UserHomeEvent, UserHomeState> {
  final GetUserDoctors getUserDoctors;

  UserHomeBloc({required this.getUserDoctors}) : super(UserHomeInitial()) {
    on<FetchUserDoctorsEvent>((event, emit) async {
      emit(UserHomeLoading());
      try {
        final doctors = await getUserDoctors();
        emit(UserHomeLoaded(doctors));
      } catch (e) {
        emit(UserHomeError(e.toString()));
      }
    });
  }
}

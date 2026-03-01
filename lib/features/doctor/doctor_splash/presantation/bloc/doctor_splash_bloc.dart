import 'package:bloc/bloc.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/usecases/doctor_is_loggedin.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/web.dart';

part 'doctor_splash_event.dart';
part 'doctor_splash_state.dart';

class DoctorSplashBloc extends Bloc<DoctorSplashEvent, DoctorSplashState> {
  final DoctorIsLoggedIn isLoggedIn;
  DoctorSplashBloc(this.isLoggedIn) : super(DoctorSplashInitial()) {
   on<CheckDoctorAuthEvent>((event, emit) async {
    Logger().i('Checking doctor authentication status...');
      final loggedIn = await isLoggedIn();
        Logger().i('Doctor authentication status: $loggedIn');
      if (loggedIn) {
        emit(DoctorLoggedIn());
      } else {
        emit(DoctorNotLoggedIn());
      }
    });
  }
}

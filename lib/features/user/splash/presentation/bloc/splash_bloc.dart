import 'package:bloc/bloc.dart';
import 'package:doctor_booking_app/features/user/auth/domain/usecase/is_logged_in.dart';
import 'package:equatable/equatable.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final IsLoggedIn isLoggedIn;
  SplashBloc(this.isLoggedIn) : super(SplashInitial()) {
    on<CheckAuthEvent>((event, emit) async {
      emit(SplashLoading());
      await Future.delayed(const Duration(seconds: 2));
      final logged=await isLoggedIn();
      if(logged){
        emit(UserLoggedIn());
      }else{
        emit(UserNotLoggedIn());
      }
    });
  }
}

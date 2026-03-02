import 'package:bloc/bloc.dart';
import 'package:doctor_booking_app/core/service/client.dart';
import 'package:doctor_booking_app/features/user/auth/domain/usecase/is_logged_in.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/web.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final IsLoggedIn isLoggedIn;
  SplashBloc(this.isLoggedIn) : super(SplashInitial()) {
    on<CheckAuthEvent>((event, emit) async {
       Logger().i("SPLASH EVENT STARTED");
      emit(SplashLoading());

      await Future.delayed(const Duration(seconds: 2));

      final user = supabase.auth.currentUser;
        Logger().i("CURRENT USER: $user");
      if (user == null) {
        Logger().i("No user logged in");
        emit(NotAuthenticated());
        return;
      }

      final profile = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

  Logger().i("PROFILE: $profile");

  if (profile == null) {
    Logger().i("PROFILE NULL → NotAuthenticated");
    emit(NotAuthenticated());
    return;
  }

      final role = profile['role'];
      Logger().i("ROLE: $role");
      if (role == 'doctor') {
        Logger().i("EMIT Doctor");
        emit(AuthenticatedAsDoctor());
      } else {
        Logger().i("EMIT User");
        emit(AuthenticatedAsUser());
      }
    });
  }
}

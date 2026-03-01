import 'package:bloc/bloc.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/entities/doctor_entity.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/usecases/doctor_signout.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/usecases/get_current_doctor.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/usecases/send_magic_link.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

part 'docto_auth_event.dart';
part 'docto_auth_state.dart';
class DoctorAuthBloc extends Bloc<DoctorAuthEvent, DoctorAuthState> {
  final SendMagicLink sendMagicLink;
  final GetCurrentDoctor getCurrentDoctor;
  final DoctorSignOut signOut;

  DoctorAuthBloc(
    this.sendMagicLink,
    this.getCurrentDoctor,
    this.signOut,
  ) : super(DoctorAuthInitial()) {

    on<SendMagicLinkEvent>((event, emit) async {
      emit(DoctorAuthLoading());
      try {
        await sendMagicLink(event.email);
        Logger().i('Magic link sent to ${event.email}');
        emit(MagicLinkSent());
      } catch (e, stackTrace) {
        Logger().e('Error sending magic link: $e', error: e, stackTrace: stackTrace);
        emit(DoctorAuthError(e.toString()));
      }
    });

    on<CheckAuthStatusEvent>((event, emit) async {
      final doctor = await getCurrentDoctor();
      if (doctor != null) {
        emit(DoctorAuthenticated(doctor));
      } else {
        emit(DoctorUnauthenticated());
      }
    });

    on<DoctorSignOutEvent>((event, emit) async {
      await signOut();
      emit(DoctorUnauthenticated());
    });
  }
}
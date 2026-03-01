import 'package:bloc/bloc.dart';
import 'package:doctor_booking_app/features/user/auth/domain/entities/user_entitt.dart';
import 'package:doctor_booking_app/features/user/auth/domain/usecase/sendotp.dart';
import 'package:doctor_booking_app/features/user/auth/domain/usecase/signout.dart';
import 'package:doctor_booking_app/features/user/auth/domain/usecase/verifyotp.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtp sendOtp;
  final VerifyOtp verifyOtp;
  final Signout signOut;
  
  AuthBloc(this.sendOtp, this.verifyOtp, this.signOut) : super(AuthInitial()) {
    on<SentOtpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await sendOtp(event.phoneNumber);
        emit(AuthOtpSent());
          Logger().i('OTP sent to ${event.phoneNumber}');
      } catch (e,strackTrace) {
        Logger().e('Error sending OTP: $e', stackTrace: strackTrace);
        emit(AuthError(e.toString()));
      }
    });
    on<VerifyOtpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await verifyOtp(event.phoneNumber, event.otp);
        emit(AuthVerified(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthSignInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await verifyOtp(event.phoneNumber, event.otp);
        emit(AuthSignInSuccess(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    on<AuthSignOutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await signOut();
        emit(AuthSignOutSuccess());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}

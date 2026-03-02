import 'package:bloc/bloc.dart';
import 'package:doctor_booking_app/core/service/app_logger.dart';
import 'package:doctor_booking_app/core/service/client.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/entities/doctor_entity.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/usecases/doctor_login.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/usecases/doctor_signup.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/usecases/doctor_signout.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/usecases/get_auth_doctor.dart';
import 'package:equatable/equatable.dart';

part 'doctor_auth_event.dart';
part 'doctor_auth_state.dart';

class DoctorAuthBloc extends Bloc<DoctorAuthEvent, DoctorAuthState> {
  final DoctorLogin doctorLogin;
  final DoctorSignUp doctorSignUp;
  final GetAuthDoctor getAuthDoctor;
  final DoctorSignOut signOut;

  DoctorAuthBloc(
    this.doctorLogin,
    this.doctorSignUp,
    this.getAuthDoctor,
    this.signOut,
  ) : super(DoctorAuthInitial()) {
    on<DoctorLoginEvent>((event, emit) async {
      AppLogger.info('Bloc: Handling DoctorLoginEvent for ${event.email}');
      emit(DoctorAuthLoading());
      try {
        await doctorLogin(event.email, event.password);
        AppLogger.info('Bloc: Login successful for ${event.email}');
        final doctorAuth = await getAuthDoctor(); // Already getAuthDoctor()
        if (doctorAuth != null) {
          // Check if doctor profile exists in 'doctors' table
          final doctorProfile = await supabase
              .from('doctors')
              .select()
              .eq('id', doctorAuth.id)
              .maybeSingle();

          if (doctorProfile == null) {
            emit(DoctorAuthNewUser(doctorAuth));
          } else {
            emit(DoctorAuthenticated(doctorAuth));
          }
        } else {
          AppLogger.error(
            'Bloc: Failed to retrieve doctor profile for ${event.email}',
          );
          emit(DoctorAuthError('Failed to retrieve doctor profile'));
        }
      } catch (e, stackTrace) {
        AppLogger.error('Bloc: Error logging in doctor: $e', e, stackTrace);
        emit(DoctorAuthError(e.toString()));
      }
    });

    on<DoctorSignUpEvent>((event, emit) async {
      AppLogger.info('Bloc: Handling DoctorSignUpEvent for ${event.email}');
      emit(DoctorAuthLoading());
      try {
        await doctorSignUp(event.email, event.password);
        AppLogger.info('Bloc: Doctor signed up with email ${event.email}');
        final doctorAuth = await getAuthDoctor(); // Already getAuthDoctor()
        if (doctorAuth != null) {
          // Check if doctor profile exists in 'doctors' table
          final doctorProfile = await supabase
              .from('doctors')
              .select()
              .eq('id', doctorAuth.id)
              .maybeSingle();

          if (doctorProfile == null) {
            emit(DoctorAuthNewUser(doctorAuth));
          } else {
            emit(DoctorAuthenticated(doctorAuth));
          }
        } else {
          AppLogger.error(
            'Bloc: Failed to retrieve profile after signup for ${event.email}',
          );
          emit(
            DoctorAuthError('Failed to retrieve doctor profile after sign up'),
          );
        }
      } catch (e, stackTrace) {
        AppLogger.error('Bloc: Error signing up doctor: $e', e, stackTrace);
        emit(DoctorAuthError(e.toString()));
      }
    });

    on<CheckAuthStatusEvent>((event, emit) async {
      AppLogger.debug('Bloc: Checking auth status');
      emit(DoctorAuthLoading());
      final doctorAuth = await getAuthDoctor();
      if (doctorAuth != null) {
        AppLogger.info('Bloc: Doctor is authenticated: ${doctorAuth.email}');

        final doctorProfile = await supabase
            .from('doctors')
            .select()
            .eq('id', doctorAuth.id)
            .maybeSingle();

        if (doctorProfile == null) {
          emit(DoctorAuthNewUser(doctorAuth));
        } else {
          emit(DoctorAuthenticated(doctorAuth));
        }
      } else {
        AppLogger.debug('Bloc: Doctor is unauthenticated');
        emit(DoctorUnauthenticated());
      }
    });

    on<DoctorSignOutEvent>((event, emit) async {
      AppLogger.info('Bloc: Handling DoctorSignOutEvent');
      await signOut();
      emit(DoctorUnauthenticated());
    });
  }
}

part of 'doctor_splash_bloc.dart';

sealed class DoctorSplashEvent extends Equatable {
  const DoctorSplashEvent();

  @override
  List<Object> get props => [];
}


final class CheckDoctorAuthEvent extends DoctorSplashEvent {}
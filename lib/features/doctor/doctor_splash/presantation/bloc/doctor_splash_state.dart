part of 'doctor_splash_bloc.dart';

sealed class DoctorSplashState extends Equatable {
  const DoctorSplashState();
  
  @override
  List<Object> get props => [];
}

final class DoctorSplashInitial extends DoctorSplashState {}

class DoctorSplashLoading extends DoctorSplashState {}
class DoctorLoggedIn extends DoctorSplashState {}
class DoctorNotLoggedIn extends DoctorSplashState {}

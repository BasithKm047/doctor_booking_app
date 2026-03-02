part of 'doctor_auth_bloc.dart';

sealed class DoctorAuthEvent extends Equatable {
  const DoctorAuthEvent();

  @override
  List<Object> get props => [];
}

class DoctorLoginEvent extends DoctorAuthEvent {
  final String email;
  final String password;

  const DoctorLoginEvent(this.email, this.password);

  @override
  List<Object> get props => [email];
}

class DoctorSignUpEvent extends DoctorAuthEvent {
  final String email;
  final String password;

  const DoctorSignUpEvent(this.email, this.password);

  @override
  List<Object> get props => [email];
}

class CheckAuthStatusEvent extends DoctorAuthEvent {}

class DoctorSignOutEvent extends DoctorAuthEvent {}

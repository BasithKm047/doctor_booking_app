part of 'doctor_auth_bloc.dart';

sealed class DoctorAuthState extends Equatable {
  const DoctorAuthState();

  @override
  List<Object> get props => [];
}

final class DoctorAuthInitial extends DoctorAuthState {}

class DoctorAuthLoading extends DoctorAuthState {}

class MagicLinkSent extends DoctorAuthState {}

class DoctorAuthenticated extends DoctorAuthState {
  final DoctorAuthEntity doctor;
  const DoctorAuthenticated(this.doctor);
}

class DoctorAuthNewUser extends DoctorAuthState {
  final DoctorAuthEntity doctor;
  const DoctorAuthNewUser(this.doctor);
}

class DoctorUnauthenticated extends DoctorAuthState {}

class DoctorAuthError extends DoctorAuthState {
  final String message;

  const DoctorAuthError(this.message);
}

class DoctorAuthSignOutSuccess extends DoctorAuthState {}

part of 'docto_auth_bloc.dart';

sealed class DoctorAuthState extends Equatable {
  const DoctorAuthState();

  @override
  List<Object> get props => [];
}

final class DoctorAuthInitial extends DoctorAuthState {}

class DoctorAuthLoading extends DoctorAuthState {}


class MagicLinkSent extends DoctorAuthState {}

class DoctorAuthenticated extends DoctorAuthState {
  final DoctorEntity doctor;
  const DoctorAuthenticated(this.doctor);
}

class DoctorUnauthenticated extends DoctorAuthState {}
class DoctorAuthError extends DoctorAuthState {
  final String message;

  const DoctorAuthError(this.message);
}

class DoctorAuthSignOutSuccess extends DoctorAuthState {}





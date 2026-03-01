part of 'docto_auth_bloc.dart';

sealed class DoctorAuthEvent extends Equatable {
  const DoctorAuthEvent();

  @override
  List<Object> get props => [];
}

class SendMagicLinkEvent extends DoctorAuthEvent {
  final String email;

  const SendMagicLinkEvent(this.email);

  @override
  List<Object> get props => [email];
}
class CheckAuthStatusEvent extends DoctorAuthEvent {}


class DoctorSignOutEvent extends DoctorAuthEvent {}


part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SentOtpEvent extends AuthEvent {
  final String phoneNumber;

  const SentOtpEvent(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String otp;

  const VerifyOtpEvent(this.phoneNumber, this.otp);

  @override
  List<Object> get props => [phoneNumber, otp];
}
final class AuthSignInEvent extends AuthEvent {
  final String phoneNumber;
  final String otp;

  const AuthSignInEvent(this.phoneNumber, this.otp);

  @override
  List<Object> get props => [phoneNumber, otp];
}


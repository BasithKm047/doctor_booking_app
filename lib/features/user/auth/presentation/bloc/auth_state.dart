part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}
final class AuthOtpSent extends AuthState {}
final class AuthVerified extends AuthState {
  final UserEntity user;

  const AuthVerified(this.user);
  @override
  List<Object> get props => [user];
}

final class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

final class AuthSignInSuccess extends AuthState {
  final UserEntity user;

  const AuthSignInSuccess(this.user);

  @override
  List<Object> get props => [user];
}
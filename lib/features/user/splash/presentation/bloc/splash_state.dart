part of 'splash_bloc.dart';

sealed class SplashState extends Equatable {
  const SplashState();
  
  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}
class SplashLoading extends SplashState {}
class NotAuthenticated extends SplashState {}
class AuthenticatedAsUser extends SplashState {}
class AuthenticatedAsDoctor extends SplashState {}
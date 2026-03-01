part of 'splash_bloc.dart';

sealed class SplashState extends Equatable {
  const SplashState();
  
  @override
  List<Object> get props => [];
}

final class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class UserLoggedIn extends SplashState {}

class UserNotLoggedIn extends SplashState {}
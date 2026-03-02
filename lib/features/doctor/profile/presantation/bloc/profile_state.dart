part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final DoctorRegistrationEntity doctor;
  const ProfileLoaded(this.doctor);

  @override
  List<Object> get props => [doctor];
}

final class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

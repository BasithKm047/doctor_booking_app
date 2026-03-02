part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchProfileEvent extends ProfileEvent {
  final String id;
  const FetchProfileEvent(this.id);

  @override
  List<Object> get props => [id];
}

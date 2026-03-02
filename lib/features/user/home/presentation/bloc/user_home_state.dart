import '../../domain/entities/user_doctor_entity.dart';

abstract class UserHomeState {}

class UserHomeInitial extends UserHomeState {}

class UserHomeLoading extends UserHomeState {}

class UserHomeLoaded extends UserHomeState {
  final List<UserDoctorEntity> doctors;
  UserHomeLoaded(this.doctors);
}

class UserHomeError extends UserHomeState {
  final String message;
  UserHomeError(this.message);
}

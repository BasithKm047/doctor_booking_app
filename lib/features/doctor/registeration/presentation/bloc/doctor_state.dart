import 'package:doctor_booking_app/features/doctor/registeration/domain/entities/doctor_registration_entity.dart';

abstract class DoctorState {}

class DoctorInitial extends DoctorState {}

class DoctorLoading extends DoctorState {}

class DoctorLoaded extends DoctorState {
  final List<DoctorRegistrationEntity> doctors;
  DoctorLoaded(this.doctors);
}

class DoctorSuccess extends DoctorState {}

class DoctorError extends DoctorState {
  final String message;
  DoctorError(this.message);
}

class ImageUploading extends DoctorState {}

class ImageUploaded extends DoctorState {
  final String url;
  ImageUploaded(this.url);
}

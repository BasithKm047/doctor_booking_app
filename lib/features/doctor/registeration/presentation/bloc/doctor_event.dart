import 'package:doctor_booking_app/features/doctor/registeration/domain/entities/doctor_registration_entity.dart';

abstract class DoctorEvent {}

class AddDoctorEvent extends DoctorEvent {
  final DoctorRegistrationEntity doctor;
  AddDoctorEvent(this.doctor);
}

class UpdateDoctorEvent extends DoctorEvent {
  final DoctorRegistrationEntity doctor;
  UpdateDoctorEvent(this.doctor);
}

class GetDoctorsEvent extends DoctorEvent {}

class DeleteDoctorEvent extends DoctorEvent {
  final String id;
  DeleteDoctorEvent(this.id);
}

class UploadImageEvent extends DoctorEvent {
  final String path;
  UploadImageEvent(this.path);
}

import 'package:equatable/equatable.dart';

abstract class DoctorAppointmentsEvent extends Equatable {
  const DoctorAppointmentsEvent();

  @override
  List<Object?> get props => [];
}

class FetchDoctorAppointmentsEvent extends DoctorAppointmentsEvent {
  final String doctorId;

  const FetchDoctorAppointmentsEvent(this.doctorId);

  @override
  List<Object?> get props => [doctorId];
}

class RejectDoctorAppointmentEvent extends DoctorAppointmentsEvent {
  final String appointmentId;

  const RejectDoctorAppointmentEvent(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

class AcceptDoctorAppointmentEvent extends DoctorAppointmentsEvent {
  final String appointmentId;

  const AcceptDoctorAppointmentEvent(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

import 'package:doctor_booking_app/features/doctor/appointment/domain/entities/appointment_request_entity.dart';
import 'package:equatable/equatable.dart';

abstract class DoctorAppointmentsState extends Equatable {
  const DoctorAppointmentsState();

  @override
  List<Object?> get props => [];
}

class DoctorAppointmentsInitial extends DoctorAppointmentsState {}

class DoctorAppointmentsLoading extends DoctorAppointmentsState {}

class DoctorAppointmentsLoaded extends DoctorAppointmentsState {
  final List<AppointmentRequest> appointments;

  const DoctorAppointmentsLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

class DoctorAppointmentsError extends DoctorAppointmentsState {
  final String message;

  const DoctorAppointmentsError(this.message);

  @override
  List<Object?> get props => [message];
}

class AppointmentRejecting extends DoctorAppointmentsState {}

class AppointmentRejectedSuccess extends DoctorAppointmentsState {
  final String appointmentId;

  const AppointmentRejectedSuccess(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

class AppointmentRejectError extends DoctorAppointmentsState {
  final String message;

  const AppointmentRejectError(this.message);

  @override
  List<Object?> get props => [message];
}

class AppointmentAccepting extends DoctorAppointmentsState {}

class AppointmentAcceptedSuccess extends DoctorAppointmentsState {
  final String appointmentId;

  const AppointmentAcceptedSuccess(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

class AppointmentAcceptError extends DoctorAppointmentsState {
  final String message;

  const AppointmentAcceptError(this.message);

  @override
  List<Object?> get props => [message];
}

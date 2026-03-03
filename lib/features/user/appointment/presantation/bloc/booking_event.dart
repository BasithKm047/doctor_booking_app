import 'package:doctor_booking_app/features/user/appointment/domain/entities/user_appointment_entity.dart';
import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class FetchAvailabilityEvent extends BookingEvent {
  final String doctorId;

  const FetchAvailabilityEvent(this.doctorId);

  @override
  List<Object> get props => [doctorId];
}

class SubmitBookingEvent extends BookingEvent {
  final UserAppointmentEntity appointment;

  const SubmitBookingEvent(this.appointment);

  @override
  List<Object> get props => [appointment];
}

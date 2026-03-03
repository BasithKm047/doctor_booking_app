import 'package:equatable/equatable.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class AvailabilityLoading extends BookingState {}

class AvailabilityLoaded extends BookingState {
  final List<Map<String, dynamic>> availability;
  final DateTime? selectedDate;
  final String? selectedTime;

  const AvailabilityLoaded({
    required this.availability,
    this.selectedDate,
    this.selectedTime,
  });

  @override
  List<Object?> get props => [availability, selectedDate, selectedTime];

  AvailabilityLoaded copyWith({
    List<Map<String, dynamic>>? availability,
    DateTime? selectedDate,
    String? selectedTime,
  }) {
    return AvailabilityLoaded(
      availability: availability ?? this.availability,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
    );
  }
}

class AvailabilityError extends BookingState {
  final String message;

  const AvailabilityError(this.message);

  @override
  List<Object> get props => [message];
}

class BookingSubmitting extends BookingState {}

class BookingSuccess extends BookingState {}

class BookingSubmitError extends BookingState {
  final String message;
  final List<Map<String, dynamic>> previousAvailability;

  const BookingSubmitError({
    required this.message,
    required this.previousAvailability,
  });

  @override
  List<Object> get props => [message, previousAvailability];
}

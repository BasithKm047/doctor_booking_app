import 'package:bloc/bloc.dart';
import 'package:doctor_booking_app/features/user/appointment/domain/usecases/book_appointment_usecase.dart';
import 'package:doctor_booking_app/features/user/appointment/domain/usecases/get_doctor_availability_usecase.dart';
import 'package:doctor_booking_app/features/user/appointment/presantation/bloc/booking_event.dart';
import 'package:doctor_booking_app/features/user/appointment/presantation/bloc/booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetDoctorAvailabilityUseCase getDoctorAvailability;
  final BookAppointmentUseCase bookAppointment;

  BookingBloc({
    required this.getDoctorAvailability,
    required this.bookAppointment,
  }) : super(BookingInitial()) {
    on<FetchAvailabilityEvent>(_onFetchAvailability);
    on<SubmitBookingEvent>(_onSubmitBooking);
  }

  Future<void> _onFetchAvailability(
    FetchAvailabilityEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(AvailabilityLoading());
    try {
      final availability = await getDoctorAvailability(event.doctorId);
      emit(AvailabilityLoaded(availability: availability));
    } catch (e) {
      emit(AvailabilityError(e.toString()));
    }
  }

  Future<void> _onSubmitBooking(
    SubmitBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    // Keep reference to previous availability state if we want to revert on error
    List<Map<String, dynamic>> previousAvailability = [];
    if (state is AvailabilityLoaded) {
      previousAvailability = (state as AvailabilityLoaded).availability;
    }

    emit(BookingSubmitting());
    try {
      await bookAppointment(event.appointment);
      emit(BookingSuccess());
    } catch (e) {
      emit(
        BookingSubmitError(
          message: e.toString(),
          previousAvailability: previousAvailability,
        ),
      );
    }
  }
}

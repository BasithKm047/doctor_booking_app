import 'package:doctor_booking_app/features/doctor/appointment/domain/usecases/accept_appointment_usecase.dart';
import 'package:doctor_booking_app/features/doctor/appointment/domain/usecases/get_doctor_appointments_usecase.dart';
import 'package:doctor_booking_app/features/doctor/appointment/domain/usecases/reject_appointment_usecase.dart';
import 'package:doctor_booking_app/features/doctor/appointment/presantation/bloc/doctor_appointments_event.dart';
import 'package:doctor_booking_app/features/doctor/appointment/presantation/bloc/doctor_appointments_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorAppointmentsBloc
    extends Bloc<DoctorAppointmentsEvent, DoctorAppointmentsState> {
  final GetDoctorAppointmentsUseCase getDoctorAppointments;
  final AcceptAppointmentUseCase acceptAppointment;
  final RejectAppointmentUseCase rejectAppointment;

  DoctorAppointmentsBloc({
    required this.getDoctorAppointments,
    required this.acceptAppointment,
    required this.rejectAppointment,
  }) : super(DoctorAppointmentsInitial()) {
    on<FetchDoctorAppointmentsEvent>(_onFetchAppointments);
    on<AcceptDoctorAppointmentEvent>(_onAcceptAppointment);
    on<RejectDoctorAppointmentEvent>(_onRejectAppointment);
  }

  Future<void> _onFetchAppointments(
    FetchDoctorAppointmentsEvent event,
    Emitter<DoctorAppointmentsState> emit,
  ) async {
    emit(DoctorAppointmentsLoading());
    try {
      final appointments = await getDoctorAppointments(event.doctorId);
      emit(DoctorAppointmentsLoaded(appointments));
    } catch (e) {
      emit(DoctorAppointmentsError('Failed to fetch appointments: \$e'));
    }
  }

  Future<void> _onAcceptAppointment(
    AcceptDoctorAppointmentEvent event,
    Emitter<DoctorAppointmentsState> emit,
  ) async {
    emit(AppointmentAccepting());
    try {
      await acceptAppointment(event.appointmentId);
      emit(AppointmentAcceptedSuccess(event.appointmentId));
    } catch (e) {
      emit(AppointmentAcceptError('Failed to accept appointment: $e'));
    }
  }

  Future<void> _onRejectAppointment(
    RejectDoctorAppointmentEvent event,
    Emitter<DoctorAppointmentsState> emit,
  ) async {
    emit(AppointmentRejecting());
    try {
      await rejectAppointment(event.appointmentId);
      emit(AppointmentRejectedSuccess(event.appointmentId));
    } catch (e) {
      emit(AppointmentRejectError('Failed to reject appointment: \$e'));
    }
  }
}

import 'dart:io';

import 'package:doctor_booking_app/core/service/client.dart';
import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/core/widgets/custom_snack_bar.dart';
import 'package:doctor_booking_app/features/doctor/appointment/domain/entities/appointment_request_entity.dart';
import 'package:doctor_booking_app/features/doctor/appointment/presantation/bloc/doctor_appointments_bloc.dart';
import 'package:doctor_booking_app/features/doctor/appointment/presantation/bloc/doctor_appointments_event.dart';
import 'package:doctor_booking_app/features/doctor/appointment/presantation/bloc/doctor_appointments_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DoctorAppointmentsPage extends StatefulWidget {
  const DoctorAppointmentsPage({super.key});

  @override
  State<DoctorAppointmentsPage> createState() => _DoctorAppointmentsPageState();
}

class _DoctorAppointmentsPageState extends State<DoctorAppointmentsPage> {
  List<AppointmentRequest> _cachedAppointments = const [];
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  void _fetchAppointments() {
    final doctorId = supabase.auth.currentUser?.id;
    if (doctorId != null) {
      context.read<DoctorAppointmentsBloc>().add(
        FetchDoctorAppointmentsEvent(doctorId),
      );
    }
  }

  void _acceptAppointment(String appointmentId) {
    context.read<DoctorAppointmentsBloc>().add(
      AcceptDoctorAppointmentEvent(appointmentId),
    );
  }

  void _rejectAppointment(String appointmentId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Appointment'),
        content: const Text(
          'Are you sure you want to reject this appointment? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<DoctorAppointmentsBloc>().add(
                RejectDoctorAppointmentEvent(appointmentId),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientAvatar(String? imagePath) {
    if (imagePath == null || imagePath.trim().isEmpty) {
      return Icon(Icons.person, color: AppColors.medConnectPrimary);
    }

    final normalized = imagePath.trim();
    if (normalized.startsWith('http://') || normalized.startsWith('https://')) {
      return ClipOval(
        child: Image.network(
          normalized,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.person, color: AppColors.medConnectPrimary),
        ),
      );
    }

    if (normalized.startsWith('assets/')) {
      return ClipOval(
        child: Image.asset(
          normalized,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.person, color: AppColors.medConnectPrimary),
        ),
      );
    }

    return ClipOval(
      child: Image.file(
        File(normalized),
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.person, color: AppColors.medConnectPrimary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'My Appointments',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<DoctorAppointmentsBloc, DoctorAppointmentsState>(
        listener: (context, state) {
          if (state is DoctorAppointmentsLoaded) {
            _cachedAppointments = state.appointments;
            _isUpdating = false;
          } else if (state is AppointmentAccepting ||
              state is AppointmentRejecting) {
            _isUpdating = true;
          } else if (state is AppointmentAcceptedSuccess) {
            _isUpdating = false;
            CustomSnackBar.show(context, 'Appointment booked');
            _fetchAppointments();
          } else if (state is AppointmentAcceptError) {
            _isUpdating = false;
            CustomSnackBar.show(context, state.message, isError: true);
          } else if (state is AppointmentRejectedSuccess) {
            _isUpdating = false;
            CustomSnackBar.show(context, 'Appointment rejected successfully');
            _fetchAppointments();
          } else if (state is AppointmentRejectError) {
            _isUpdating = false;
            CustomSnackBar.show(context, state.message, isError: true);
          }
        },
        builder: (context, state) {
          if (state is DoctorAppointmentsLoading &&
              _cachedAppointments.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.medConnectPrimary,
              ),
            );
          }

          if (state is DoctorAppointmentsError && _cachedAppointments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load appointments',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _fetchAppointments,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.medConnectPrimary,
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          final appointments = state is DoctorAppointmentsLoaded
              ? state.appointments
              : _cachedAppointments;

          if (appointments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'No appointments found.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async => _fetchAppointments(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    final appointmentNote =
                        appointment.note ?? appointment.appointmentType;
                    final isPending =
                        appointment.status == AppointmentStatus.pending;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppColors.medConnectPrimary
                                      .withOpacity(0.1),
                                  child: _buildPatientAvatar(
                                    appointment.patientImageUrl,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appointment.patientName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Reason: $appointmentNote',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: AppColors.medConnectPrimary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormat(
                                      'MMM dd, yyyy',
                                    ).format(appointment.appointmentTime),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: AppColors.medConnectPrimary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormat(
                                      'hh:mm a',
                                    ).format(appointment.appointmentTime),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (isPending)
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () =>
                                          _acceptAppointment(appointment.id),
                                      icon: const Icon(Icons.check, size: 18),
                                      label: const Text('Accept'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors.medConnectPrimary,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () =>
                                          _rejectAppointment(appointment.id),
                                      icon: const Icon(Icons.close, size: 18),
                                      label: const Text('Reject'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: const BorderSide(
                                          color: Colors.red,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Confirmed',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_isUpdating)
                const Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.medConnectPrimary,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

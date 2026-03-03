import 'package:doctor_booking_app/core/service/client.dart';
import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/core/widgets/custom_snack_bar.dart';
import 'package:doctor_booking_app/features/doctor/appointment/domain/entities/appointment_request_entity.dart';
import 'package:doctor_booking_app/features/doctor/appointment/presantation/bloc/doctor_appointments_bloc.dart';
import 'package:doctor_booking_app/features/doctor/appointment/presantation/bloc/doctor_appointments_event.dart';
import 'package:doctor_booking_app/features/doctor/appointment/presantation/bloc/doctor_appointments_state.dart';
import 'package:doctor_booking_app/features/doctor/appointment/presantation/pages/doctor_appointments_page.dart';
import 'package:doctor_booking_app/features/doctor/auth/presentation/bloc/doctor_auth_bloc.dart';
import 'package:doctor_booking_app/features/doctor/home_screen/domain/entities/doctor_request_entity.dart';
import 'package:doctor_booking_app/features/doctor/home_screen/domain/entities/schedule_item_entity.dart';
import 'package:doctor_booking_app/features/doctor/home_screen/presentation/widgets/availability_status_card.dart';
import 'package:doctor_booking_app/features/doctor/home_screen/presentation/widgets/home_header.dart';
import 'package:doctor_booking_app/features/doctor/home_screen/presentation/widgets/pending_request_card.dart';
import 'package:doctor_booking_app/features/doctor/home_screen/presentation/widgets/schedule_timeline_item.dart';
import 'package:doctor_booking_app/features/doctor/notification/presentation/pages/doctor_notifications_page.dart';
import 'package:doctor_booking_app/features/doctor/profile/presantation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  List<AppointmentRequest> _cachedAppointments = const [];
  final Set<String> _dismissedNotificationIds = <String>{};

  @override
  void initState() {
    super.initState();
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      context.read<ProfileBloc>().add(FetchProfileEvent(userId));
      context.read<DoctorAppointmentsBloc>().add(
        FetchDoctorAppointmentsEvent(userId),
      );
    }
  }

  void _refreshAppointments() {
    final doctorId = supabase.auth.currentUser?.id;
    if (doctorId != null) {
      context.read<DoctorAppointmentsBloc>().add(
        FetchDoctorAppointmentsEvent(doctorId),
      );
    }
  }

  List<DoctorRequest> _pendingRequestsFrom(
    List<AppointmentRequest> appointments,
  ) {
    return appointments
        .where((item) => item.status == AppointmentStatus.pending)
        .map(
          (item) => DoctorRequest(
            id: item.id,
            patientName: item.patientName,
            appointmentType: item.note ?? item.appointmentType,
            patientImageUrl: item.patientImageUrl ?? '',
            appointmentTime: item.appointmentTime,
            isNew: item.isNew,
          ),
        )
        .toList()
      ..sort((a, b) => a.appointmentTime.compareTo(b.appointmentTime));
  }

  List<ScheduleItem> _todayScheduleFrom(List<AppointmentRequest> appointments) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    bool isSchedulable(AppointmentRequest item) {
      return item.status == AppointmentStatus.pending ||
          item.status == AppointmentStatus.confirmed;
    }

    final todayAppointments = appointments.where((item) {
      final at = item.appointmentTime;
      final isToday = !at.isBefore(today) && at.isBefore(tomorrow);
      return isToday && isSchedulable(item);
    }).toList()..sort((a, b) => a.appointmentTime.compareTo(b.appointmentTime));

    final source = todayAppointments.isNotEmpty
        ? todayAppointments
        : appointments.where((item) {
            final at = item.appointmentTime;
            return !at.isBefore(today) && isSchedulable(item);
          }).toList()
          ..sort((a, b) => a.appointmentTime.compareTo(b.appointmentTime));

    return source
        .take(5)
        .map(
          (item) => ScheduleItem(
            id: item.id,
            time: item.appointmentTime,
            title: item.patientName,
            location:
                '${DateFormat('EEE, MMM d').format(item.appointmentTime)} • ${item.note ?? item.appointmentType}',
            isHighPriority: item.appointmentTime.isAfter(now),
            status: item.status == AppointmentStatus.confirmed
                ? ScheduleStatus.confirmed
                : ScheduleStatus.pending,
          ),
        )
        .toList();
  }

  Future<void> _openNotifications(
    List<AppointmentRequest> newAppointments,
  ) async {
    final deletedIds = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorNotificationsPage(notifications: newAppointments),
      ),
    );

    if (deletedIds is List) {
      setState(() {
        _dismissedNotificationIds.addAll(deletedIds.whereType<String>());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorAppointmentsBloc, DoctorAppointmentsState>(
      listener: (context, appointmentState) {
        if (appointmentState is DoctorAppointmentsLoaded) {
          _cachedAppointments = appointmentState.appointments;
        } else if (appointmentState is AppointmentAcceptedSuccess) {
          CustomSnackBar.show(context, 'Appointment booked');
          _refreshAppointments();
        } else if (appointmentState is AppointmentAcceptError) {
          CustomSnackBar.show(context, appointmentState.message, isError: true);
        } else if (appointmentState is AppointmentRejectedSuccess) {
          CustomSnackBar.show(context, 'Appointment rejected successfully');
          _refreshAppointments();
        } else if (appointmentState is AppointmentRejectError) {
          CustomSnackBar.show(context, appointmentState.message, isError: true);
        }
      },
      builder: (context, appointmentState) {
        final appointments = appointmentState is DoctorAppointmentsLoaded
            ? appointmentState.appointments
            : _cachedAppointments;

        final pendingRequests = _pendingRequestsFrom(appointments);
        final visiblePending = pendingRequests.take(3).toList();
        final todaySchedule = _todayScheduleFrom(appointments);
        final newAppointments = appointments
            .where((item) => !_dismissedNotificationIds.contains(item.id))
            .where(
              (item) => item.isNew && item.status == AppointmentStatus.pending,
            )
            .toList();

        return Scaffold(
          backgroundColor: AppColors.medConnectBackground,
          body: SafeArea(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, profileState) {
                if (profileState is ProfileLoading && appointments.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (profileState is ProfileError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${profileState.message}',
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            final authState = context
                                .read<DoctorAuthBloc>()
                                .state;
                            if (authState is DoctorAuthenticated) {
                              context.read<ProfileBloc>().add(
                                FetchProfileEvent(authState.doctor.id),
                              );
                              _refreshAppointments();
                            }
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                String name = 'Doctor';
                String specialty = 'General';
                String imageUrl = 'assets/images/doctor_image_1.png';

                if (profileState is ProfileLoaded) {
                  name = profileState.doctor.name;
                  specialty = profileState.doctor.specialization;
                  imageUrl = profileState.doctor.profileImage ?? imageUrl;
                }

                return Column(
                  children: [
                    HomeHeader(
                      doctorName: name,
                      specialty: specialty,
                      imageUrl: imageUrl,
                      notificationCount: newAppointments.length,
                      onNotificationTap: () =>
                          _openNotifications(newAppointments),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async => _refreshAppointments(),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AvailabilityStatusCard(),
                              _buildSectionHeader(
                                title: 'Pending Requests',
                                trailing: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildBadge(
                                      '${newAppointments.length} NEW',
                                    ),
                                    const SizedBox(width: 12),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const DoctorAppointmentsPage(),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Text(
                                        'View All',
                                        style: TextStyle(
                                          color: AppColors.medConnectPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (visiblePending.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    'No pending requests',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              else
                                ...visiblePending.map(
                                  (request) => PendingRequestCard(
                                    request: request,
                                    onAccept: () {
                                      context
                                          .read<DoctorAppointmentsBloc>()
                                          .add(
                                            AcceptDoctorAppointmentEvent(
                                              request.id,
                                            ),
                                          );
                                    },
                                    onReject: () {
                                      context
                                          .read<DoctorAppointmentsBloc>()
                                          .add(
                                            RejectDoctorAppointmentEvent(
                                              request.id,
                                            ),
                                          );
                                    },
                                  ),
                                ),
                              const SizedBox(height: 10),
                              _buildSectionHeader(
                                title: 'Today\'s Schedule',
                                trailing: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const DoctorAppointmentsPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'View All',
                                    style: TextStyle(
                                      color: AppColors.medConnectPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              if (todaySchedule.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    'No scheduled appointments for today',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              else
                                ...todaySchedule.asMap().entries.map(
                                  (entry) => ScheduleTimelineItem(
                                    item: entry.value,
                                    isLast:
                                        entry.key == todaySchedule.length - 1,
                                  ),
                                ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader({required String title, Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.medConnectTitle,
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.medConnectPrimary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

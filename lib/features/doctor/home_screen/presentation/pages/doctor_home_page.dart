import 'package:doctor_booking_app/core/service/client.dart';
import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/features/doctor/appointment/presantation/pages/doctor_appointments_page.dart';
import 'package:doctor_booking_app/features/doctor/auth/presentation/bloc/doctor_auth_bloc.dart';
import 'package:doctor_booking_app/features/doctor/home_screen/domain/entities/doctor_request_entity.dart';
import 'package:doctor_booking_app/features/doctor/home_screen/domain/entities/schedule_item_entity.dart';
import 'package:doctor_booking_app/features/doctor/home_screen/presentation/widgets/availability_status_card.dart';
import 'package:doctor_booking_app/features/doctor/home_screen/presentation/widgets/home_header.dart';
import 'package:doctor_booking_app/features/doctor/home_screen/presentation/widgets/pending_request_card.dart';
import 'package:doctor_booking_app/features/doctor/home_screen/presentation/widgets/schedule_timeline_item.dart';
import 'package:doctor_booking_app/features/doctor/profile/presantation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  @override
  void initState() {
    super.initState();
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      context.read<ProfileBloc>().add(FetchProfileEvent(userId));
    }
  }

  final List<DoctorRequest> _mockRequests = [
    DoctorRequest(
      id: '1',
      patientName: 'John Doe',
      appointmentType: 'Hypertension Follow-up',
      patientImageUrl: 'assets/images/patient_image_1.png',
      appointmentTime: DateTime.now().add(const Duration(hours: 1)),
      isNew: true,
    ),
    DoctorRequest(
      id: '2',
      patientName: 'Emily Watson',
      appointmentType: 'Initial Consultation',
      patientImageUrl: 'assets/images/patient_image_1.png',
      appointmentTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
    ),
  ];

  final List<ScheduleItem> _mockSchedule = [
    ScheduleItem(
      id: '1',
      time: DateTime.now().copyWith(hour: 9, minute: 0),
      title: 'Morning Rounds',
      location: 'St. Mary\'s Hospital',
    ),
    ScheduleItem(
      id: '2',
      time: DateTime.now().copyWith(hour: 10, minute: 30),
      title: 'Robert Chen',
      location: 'Clinic Visit • Room 402',
      isHighPriority: true,
    ),
    ScheduleItem(
      id: '3',
      time: DateTime.now().copyWith(hour: 11, minute: 45),
      title: 'Staff Meeting',
      location: 'Conference Hall B',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.medConnectBackground,
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final authState = context.read<DoctorAuthBloc>().state;
                        if (authState is DoctorAuthenticated) {
                          context.read<ProfileBloc>().add(
                            FetchProfileEvent(authState.doctor.id),
                          );
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

            if (state is ProfileLoaded) {
              name = state.doctor.name;
              specialty = state.doctor.specialization;
              imageUrl = state.doctor.profileImage ?? imageUrl;
            }

            return Column(
              children: [
                HomeHeader(
                  doctorName: name,
                  specialty: specialty,
                  imageUrl: imageUrl,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AvailabilityStatusCard(),
                        _buildSectionHeader(
                          title: 'Pending Requests',
                          trailing: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildBadge('3 NEW'),
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
                        ..._mockRequests.map(
                          (request) => PendingRequestCard(
                            request: request,
                            onAccept: () {},
                            onReject: () {},
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildSectionHeader(
                          title: 'Today\'s Schedule',
                          trailing: TextButton(
                            onPressed: () {},
                            child: const Text(
                              'View Calendar',
                              style: TextStyle(
                                color: AppColors.medConnectPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        ..._mockSchedule.asMap().entries.map(
                          (entry) => ScheduleTimelineItem(
                            item: entry.value,
                            isLast: entry.key == _mockSchedule.length - 1,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
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

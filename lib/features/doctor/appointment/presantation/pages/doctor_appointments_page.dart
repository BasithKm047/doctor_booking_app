import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/features/doctor/appointment/domain/entities/appointment_request_entity.dart';
import 'package:doctor_booking_app/features/doctor/appointment/presantation/widgets/appointment_request_card.dart';
import 'package:flutter/material.dart';

class DoctorAppointmentsPage extends StatefulWidget {
  const DoctorAppointmentsPage({super.key});

  @override
  State<DoctorAppointmentsPage> createState() => _DoctorAppointmentsPageState();
}

class _DoctorAppointmentsPageState extends State<DoctorAppointmentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<AppointmentRequest> _mockAppointments = [
    AppointmentRequest(
      id: '1',
      patientName: 'Sarah Jenkins',
      patientId: '88219',
      patientImageUrl: 'assets/images/patient_image_1.png',
      appointmentTime: DateTime.now().copyWith(hour: 10, minute: 30),
      appointmentType: 'Annual Physical Exam',
      note:
          'I\'ve been feeling a bit fatigued lately and need a general check-up and blood work consultation.',
      isNew: true,
      status: AppointmentStatus.pending,
    ),
    AppointmentRequest(
      id: '2',
      patientName: 'Michael Chen',
      patientId: '90212',
      patientImageUrl: 'assets/images/patient_image_1.png',
      appointmentTime: DateTime.now()
          .add(const Duration(days: 1))
          .copyWith(hour: 14, minute: 15),
      appointmentType: 'Follow-up: Sprained Ankle',
      note:
          'Swelling has gone down but still experiencing sharp pain when walking. Need to check if I can start physio.',
      status: AppointmentStatus.pending,
    ),
    AppointmentRequest(
      id: '3',
      patientName: 'Elena Rodriguez',
      patientId: '77103',
      patientImageUrl: 'assets/images/patient_image_1.png',
      appointmentTime: DateTime.now()
          .add(const Duration(days: 2))
          .copyWith(hour: 9, minute: 0),
      appointmentType: 'Prescription Renewal',
      note:
          'Routine renewal for blood pressure medication. Need to discuss dosage adjustments.',
      status: AppointmentStatus.pending,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.medConnectBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: AppColors.medConnectTitle),
        //   onPressed: () {},
        // ),
        title: Column(
          children: [
            const Text(
              'Appointment Requests',
              style: TextStyle(
                color: AppColors.medConnectTitle,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Manage incoming patient bookings',
              style: TextStyle(
                color: AppColors.medConnectSubtitle.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.search, color: AppColors.medConnectTitle),
        //     onPressed: () {},
        //   ),
        //   IconButton(
        //     icon: const Icon(Icons.tune, color: AppColors.medConnectTitle),
        //     onPressed: () {},
        //   ),
        // ],
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.medConnectPrimary,
          unselectedLabelColor: AppColors.medConnectSubtitle,
          indicatorColor: AppColors.medConnectPrimary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          tabs: [
            Tab(
              text:
                  'Pending (${_mockAppointments.where((e) => e.status == AppointmentStatus.pending).length})',
            ),
            const Tab(text: 'Confirmed'),
            const Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentsList(AppointmentStatus.pending),
          _buildAppointmentsList(AppointmentStatus.confirmed),
          _buildAppointmentsList(AppointmentStatus.past),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(AppointmentStatus status) {
    final filteredList = _mockAppointments
        .where((e) => e.status == status)
        .toList();

    if (filteredList.isEmpty) {
      return const Center(
        child: Text(
          'No appointments found',
          style: TextStyle(color: AppColors.medConnectSubtitle),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final request = filteredList[index];
        return AppointmentRequestCard(
          request: request,
          onAccept: () {},
          onDecline: () {},
        );
      },
    );
  }
}

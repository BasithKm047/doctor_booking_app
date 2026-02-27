import 'package:flutter/material.dart';
import '../../../home/domain/models/appointment.dart';
import '../widgets/appointment_card.dart';
import '../widgets/appointment_section_header.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appointments = [
      Appointment(
        id: '1',
        doctorName: 'Dr. Sarah Jenkins',
        specialty: 'Senior Cardiologist',
        date: 'Oct 24, 2023',
        time: '10:00 AM',
        imagePath: 'assets/images/doctor_image_1.png',
      ),
      Appointment(
        id: '2',
        doctorName: 'Dr. Marcus Thorne',
        specialty: 'Dermatology Specialist',
        date: 'Nov 02, 2023',
        time: '02:30 PM',
        imagePath: 'assets/images/doctor_image_1.png',
      ),
      Appointment(
        id: '3',
        doctorName: 'Dr. Elena Rodriguez',
        specialty: 'Neurologist',
        date: 'Nov 15, 2023',
        time: '09:15 AM',
        imagePath: 'assets/images/doctor_image_1.png',
      ),
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
            onPressed: () {},
          ),
          title: const Text(
            'Appointments',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Color(0xFF1E293B),
            indicatorWeight: 3,
            labelColor: Color(0xFF1E293B),
            unselectedLabelColor: Color(0xFF94A3B8),
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUpcomingList(appointments),
            const Center(child: Text('No Past Appointments')),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingList(List<Appointment> appointments) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const AppointmentSectionHeader(title: 'Next Scheduled'),
        AppointmentCard(appointment: appointments[0]),
        const AppointmentSectionHeader(title: 'Later This Month'),
        AppointmentCard(appointment: appointments[1]),
        AppointmentCard(appointment: appointments[2]),
        const SizedBox(height: 16),
      ],
    );
  }
}

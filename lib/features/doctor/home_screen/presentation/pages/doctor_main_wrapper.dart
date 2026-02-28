import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/features/doctor/appointment/presantation/pages/doctor_appointments_page.dart';
import 'package:doctor_booking_app/features/doctor/profile/presantation/pages/doctor_profile_page.dart';
import 'package:doctor_booking_app/features/doctor/shedule/presantation/pages/doctor_schedule_page.dart';
import 'package:doctor_booking_app/features/doctor/home_screen/presentation/pages/doctor_home_page.dart';
import 'package:flutter/material.dart';

class DoctorMainWrapper extends StatefulWidget {
  final int initialIndex;
  const DoctorMainWrapper({super.key, this.initialIndex = 0});

  @override
  State<DoctorMainWrapper> createState() => _DoctorMainWrapperState();
}

class _DoctorMainWrapperState extends State<DoctorMainWrapper> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    const DoctorHomePage(),
    const DoctorAppointmentsPage(),
    const DoctorSchedulePage(),
    const DoctorProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade100, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.medConnectPrimary,
          unselectedItemColor: AppColors.medConnectSubtitle,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'DASHBOARD',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'APPOINTMENTS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              activeIcon: Icon(Icons.event_note),
              label: 'SCHEDULE',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'PROFILE',
            ),
          ],
        ),
      ),
    );
  }
}

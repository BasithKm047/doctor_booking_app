import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/features/doctor/shedule/domain/entities/availability_day_entity.dart';
import 'package:doctor_booking_app/features/doctor/shedule/presantation/widgets/working_hour_card.dart';
import 'package:flutter/material.dart';

class DoctorSchedulePage extends StatefulWidget {
  const DoctorSchedulePage({super.key});

  @override
  State<DoctorSchedulePage> createState() => _DoctorSchedulePageState();
}

class _DoctorSchedulePageState extends State<DoctorSchedulePage> {
  final List<AvailabilityDay> _availability = [
    const AvailabilityDay(dayName: 'Monday', shortDayName: 'M', isActive: true),
    const AvailabilityDay(
      dayName: 'Tuesday',
      shortDayName: 'T',
      isActive: true,
    ),
    const AvailabilityDay(
      dayName: 'Wednesday',
      shortDayName: 'W',
      isActive: true,
      endTime: '12:00 PM',
      isHalfDay: true,
    ),
    const AvailabilityDay(
      dayName: 'Thursday',
      shortDayName: 'T',
      isActive: true,
    ),
    const AvailabilityDay(dayName: 'Friday', shortDayName: 'F', isActive: true),
    const AvailabilityDay(
      dayName: 'Saturday',
      shortDayName: 'S',
      isActive: false,
    ),
    const AvailabilityDay(
      dayName: 'Sunday',
      shortDayName: 'S',
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.medConnectBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.medConnectTitle),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Availability Settings',
          style: TextStyle(
            color: AppColors.medConnectTitle,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusSection(),
                  const SizedBox(height: 24),
                  _buildSectionHeader(Icons.calendar_month, 'Available Days'),
                  const SizedBox(height: 16),
                  _buildDaySelector(),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionHeader(
                        Icons.access_time_filled,
                        'Working Hours',
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Apply to all',
                          style: TextStyle(
                            color: AppColors.medConnectPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._availability.map(
                    (day) => WorkingHourCard(
                      day: day,
                      onToggle: (val) {
                        setState(() {
                          final index = _availability.indexOf(day);
                          _availability[index] = day.copyWith(isActive: val);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.02)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURRENT STATUS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: AppColors.medConnectSubtitle.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Taking Appointments',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors
                      .medConnectPrimary, // Changed from orange to primary
                ),
              ),
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.greenAccent, blurRadius: 4),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.medConnectPrimary),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.medConnectTitle,
          ),
        ),
      ],
    );
  }

  Widget _buildDaySelector() {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _availability.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final day = _availability[index];
          return Container(
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: day.isActive
                    ? AppColors.medConnectPrimary
                    : AppColors.medConnectBackground,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.dayName.substring(0, 3).toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: day.isActive
                        ? AppColors.medConnectPrimary
                        : AppColors.medConnectSubtitle,
                  ),
                ),
                Text(
                  day.shortDayName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: day.isActive
                        ? AppColors.medConnectTitle
                        : AppColors.medConnectSubtitle.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.medConnectPrimary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Save Availability',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

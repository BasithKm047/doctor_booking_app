import 'package:flutter/material.dart';
import '../../domain/models/doctor.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/doctor_details_header.dart';
import '../widgets/doctor_availability_picker.dart';
import '../widgets/doctor_location_card.dart';
import 'payment_page.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    // Ensure keyboard is dismissed when viewing doctor details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Doctor Profile',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF0F172A)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: DoctorDetailsHeader(doctor: doctor)),
            const SizedBox(height: 32),
            const Text(
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              doctor.about,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            const DoctorAvailabilityPicker(),
            const SizedBox(height: 32),
            const DoctorLocationCard(),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(doctor: doctor),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.medConnectPrimary,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 4,
                shadowColor: AppColors.medConnectPrimary.withValues(alpha: 0.4),
              ),
              child: const Text(
                'Book Appointment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

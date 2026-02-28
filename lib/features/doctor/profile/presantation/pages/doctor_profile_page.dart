import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/features/doctor/profile/presantation/widgets/profile_header.dart';
import 'package:doctor_booking_app/features/doctor/profile/presantation/widgets/profile_menu_item.dart';
import 'package:flutter/material.dart';

class DoctorProfilePage extends StatelessWidget {
  const DoctorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.medConnectBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: AppColors.medConnectTitle,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.medConnectTitle,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProfileHeader(),
            const SizedBox(height: 12),
            _buildActionCard(
              title: 'Account Settings',
              items: [
                ProfileMenuItem(
                  icon: Icons.person_outline,
                  title: 'Personal Information',
                  subtitle: 'Name, Phone, Email',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.history_edu_outlined,
                  title: 'Professional Details',
                  subtitle: 'License, Education, Bio',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.business_outlined,
                  title: 'Clinic Settings',
                  subtitle: 'Address, Fees, Hours',
                  onTap: () {},
                ),
              ],
            ),
            _buildActionCard(
              title: 'App Settings',
              items: [
                ProfileMenuItem(
                  icon: Icons.notifications_none,
                  title: 'Notifications',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.lock_outline,
                  title: 'Security',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {},
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 12),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Text(
              'App Version 1.0.2',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.medConnectSubtitle,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 16, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.medConnectSubtitle,
              ),
            ),
          ),
          ...items,
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

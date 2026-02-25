import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () {},
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: Color(0xFF1E293B),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: ProfileHeader()),
            const SizedBox(height: 40),
            const Text(
              'ACCOUNT SETTINGS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF94A3B8),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            ProfileMenuItem(
              icon: Icons.person_outline,
              title: 'Personal Information',
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.assignment_outlined,
              title: 'Medical History',
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Payment Methods',
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            ProfileMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              isLogout: true,
              textColor: const Color(0xFFEF4444),
              onTap: () {},
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

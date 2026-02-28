import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const HomeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
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
        items: [
          _buildNavItem(Icons.dashboard, Icons.dashboard_outlined, 'Dashboard'),
          _buildNavItem(
            Icons.calendar_month,
            Icons.calendar_month_outlined,
            'Schedule',
          ),
          _buildNavItem(
            Icons.chat_bubble,
            Icons.chat_bubble_outline,
            'Messages',
            hasNotification: true,
          ),
          _buildNavItem(Icons.person, Icons.person_outline, 'Profile'),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData activeIcon,
    IconData inactiveIcon,
    String label, {
    bool hasNotification = false,
  }) {
    return BottomNavigationBarItem(
      icon: Stack(
        children: [
          Icon(inactiveIcon),
          if (hasNotification)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.medConnectPrimary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      activeIcon: Icon(activeIcon),
      label: label,
    );
  }
}

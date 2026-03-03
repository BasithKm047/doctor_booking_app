import 'dart:io';
import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String imageUrl;
  final VoidCallback? onNotificationTap;
  final int notificationCount;

  const HomeHeader({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.imageUrl,
    this.onNotificationTap,
    this.notificationCount = 0,
  });

  Widget _buildImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: _errorIcon,
      );
    } else if (path.contains('/') || path.contains('\\')) {
      return Image.file(
        File(path),
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        errorBuilder: _errorIcon,
      );
    } else {
      return Image.asset(
        path,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        errorBuilder: _errorIcon,
      );
    }
  }

  Widget _errorIcon(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) => Container(
    width: 60,
    height: 60,
    decoration: const BoxDecoration(
      color: Colors.blueGrey,
      shape: BoxShape.circle,
    ),
    child: const Icon(Icons.person, color: Colors.white, size: 30),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.medConnectDotInactive,
                  width: 1,
                ),
              ),
              child: ClipOval(child: _buildImage(imageUrl)),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctorName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.medConnectTitle,
                  ),
                ),
                Text(
                  specialty.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.medConnectSubtitle,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: onNotificationTap,
                icon: const Icon(
                  Icons.notifications,
                  color: AppColors.medConnectPrimary,
                  size: 28,
                ),
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        notificationCount > 9 ? '9+' : '$notificationCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

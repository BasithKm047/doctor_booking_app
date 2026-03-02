import 'dart:io';
import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/entities/doctor_registration_entity.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final DoctorRegistrationEntity doctor;

  const ProfileHeader({super.key, required this.doctor});

  Widget _buildImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: _errorIcon,
      );
    } else if (path.contains('/') || path.contains('\\')) {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        errorBuilder: _errorIcon,
      );
    } else {
      return Image.asset(
        path,
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
    color: Colors.blueGrey,
    child: const Icon(Icons.person, color: Colors.white, size: 50),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.medConnectSubtitle.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: ClipOval(
                  child: _buildImage(
                    doctor.profileImage ?? 'assets/images/doctor_image_1.png',
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.medConnectPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            doctor.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.medConnectTitle,
            ),
          ),
          Text(
            '${doctor.specialization} • Professional Profile',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.medConnectSubtitle,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('Experience', '${doctor.experience} Yrs'),
              _buildDivider(),
              _buildStatItem(
                'Consultation',
                '₹${doctor.consultationFee.toInt()}',
              ),
              _buildDivider(),
              _buildStatItem('Rating', '4.9'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.medConnectTitle,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.medConnectSubtitle,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: Colors.grey.shade200);
  }
}

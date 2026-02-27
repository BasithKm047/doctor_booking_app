import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../domain/models/medical_category.dart';

class CategoryIcon extends StatelessWidget {
  final MedicalCategory category;
  const CategoryIcon({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80, // Slightly larger to match the image feel
          width: 80,
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC), // Very light grey
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              category.icon,
              color: AppColors.medConnectPrimary.withValues(alpha: 0.8), // Slate icon color
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          category.title,
          style:  TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.medConnectPrimary.withValues(alpha: 0.8), // Dark slate/black text
          ),
        ),
      ],
    );
  }
}

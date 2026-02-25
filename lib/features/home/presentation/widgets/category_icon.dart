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
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: category.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(category.icon, color: category.color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          category.title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}

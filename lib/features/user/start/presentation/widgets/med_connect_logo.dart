import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class MedConnectLogo extends StatelessWidget {
  final double size;
  const MedConnectLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.medConnectPrimary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.medical_services, color: Colors.white, size: 24),
      ),
    );
  }
}

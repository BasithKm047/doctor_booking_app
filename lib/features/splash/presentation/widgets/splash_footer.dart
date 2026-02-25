import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SplashFooter extends StatelessWidget {
  const SplashFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_outlined, color: AppColors.brandBlue, size: 20),
          const SizedBox(width: 8),
          Text(
            'Secure & Professional',
            style: TextStyle(
              color: AppColors.brandBlue,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

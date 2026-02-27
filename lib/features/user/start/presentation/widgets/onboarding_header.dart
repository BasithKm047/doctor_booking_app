import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import 'med_connect_logo.dart';

class OnboardingHeader extends StatelessWidget {
  final VoidCallback? onSkip;

  const OnboardingHeader({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          const MedConnectLogo(size: 40),
          const SizedBox(width: 12),
          const Text(
            'MedConnect',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.medConnectTitle,
            ),
          ),
          if (onSkip != null) ...[
            const Spacer(),
            TextButton(
              onPressed: onSkip!,
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: AppColors.medConnectPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

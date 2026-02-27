import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AuthToggleSection extends StatelessWidget {
  final ValueNotifier<bool> isLoginNotifier;
  final VoidCallback onToggle;

  const AuthToggleSection({
    super.key,
    required this.isLoginNotifier,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isLoginNotifier,
      builder: (context, isLogin, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLogin ? "Don't have an account? " : "Already have an account? ",
              style: const TextStyle(color: AppColors.medConnectSubtitle),
            ),
            GestureDetector(
              onTap: onToggle,
              child: Text(
                isLogin ? 'Register' : 'Login',
                style: const TextStyle(
                  color: AppColors.medConnectPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

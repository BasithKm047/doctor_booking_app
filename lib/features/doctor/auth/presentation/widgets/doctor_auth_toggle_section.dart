import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DoctorAuthToggleSection extends StatelessWidget {
  final ValueNotifier<bool> isLoginNotifier;
  final VoidCallback onToggle;

  const DoctorAuthToggleSection({
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
              isLogin ? "Not registered as doctor? " : "Already registered? ",
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

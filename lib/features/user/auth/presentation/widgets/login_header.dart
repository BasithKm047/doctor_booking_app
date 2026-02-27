import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../splash/presentation/widgets/brand_logo.dart';

class LoginHeader extends StatelessWidget {
  final ValueNotifier<bool> isLoginNotifier;

  const LoginHeader({super.key, required this.isLoginNotifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BrandLogo(size: 120),
        const SizedBox(height: 24),
        ValueListenableBuilder<bool>(
          valueListenable: isLoginNotifier,
          builder: (context, isLogin, child) {
            return Column(
              children: [
                Text(
                  isLogin ? 'Welcome Back' : 'Create Account',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.medConnectTitle,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  isLogin
                      ? 'Enter your details to access your health dashboard'
                      : 'Join MedConnect to access world-class healthcare',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.medConnectSubtitle,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

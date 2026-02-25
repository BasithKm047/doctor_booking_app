import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
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
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.medConnectTitle,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isLogin
                      ? 'Enter your details to access your health dashboard'
                      : 'Join MedConnect to access world-class healthcare',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
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

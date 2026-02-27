import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../../user/splash/presentation/widgets/brand_logo.dart';

class DoctorLoginHeader extends StatelessWidget {
  final ValueNotifier<bool> isLoginNotifier;

  const DoctorLoginHeader({super.key, required this.isLoginNotifier});

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
                  isLogin ? 'Doctor Login' : 'Doctor Registration',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.medConnectTitle,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  isLogin
                      ? 'Welcome doctor, please login to manage your hub'
                      : 'Join MedConnect as a healthcare professional',
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

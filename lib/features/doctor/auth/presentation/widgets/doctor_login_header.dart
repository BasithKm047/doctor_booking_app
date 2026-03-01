import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../../user/splash/presentation/widgets/brand_logo.dart';

class DoctorLoginHeader extends StatelessWidget {
  const DoctorLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BrandLogo(size: 120),
        const SizedBox(height: 24),
        Column(
          children: [
            Text(
              'Doctor Login',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.medConnectTitle,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Welcome doctor, please login to manage your hub',

              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.medConnectSubtitle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

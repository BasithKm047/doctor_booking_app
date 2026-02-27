import 'package:doctor_booking_app/features/user/auth/presentation/pages/login_page.dart';
import 'package:doctor_booking_app/features/user/start/domain/models/onboarding_item.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_primary_button.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_content_card.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  void _onNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onboardingItem = OnboardingItem(
      image: 'assets/images/doctor_image_1.png',
      title: 'Find the best doctors\nnear you.',
      subtitle: 'Booking made easy.',
      imageFit: BoxFit.contain,
    );

    return Scaffold(
      backgroundColor: AppColors.medConnectBackground,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildSimpleHeader(),
            Expanded(
              child: Center(child: OnboardingContentCard(item: onboardingItem)),
            ),
            _buildFixedFooter(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: OnboardingHeader(onSkip: null),
    );
  }

  Widget _buildFixedFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 48),
          AppPrimaryButton(
            text: 'Get Started',
            onPressed: () => _onNext(context),
            icon: Icons.arrow_forward,
            backgroundColor: AppColors.medConnectPrimary,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(isInitialLogin: true),
                ),
              );
            },
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.medConnectSubtitle,
                ),
                children: [
                  TextSpan(text: 'Already have an account? '),
                  TextSpan(
                    text: 'Log in',
                    style: TextStyle(
                      color: AppColors.medConnectPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

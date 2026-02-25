import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/onboarding_item.dart';

class OnboardingContentCard extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingContentCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image Card
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(32),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  item.image,
                  fit: item.imageFit,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person, size: 80, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Title
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.medConnectTitle,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          // Subtitle
          Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.medConnectSubtitle,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

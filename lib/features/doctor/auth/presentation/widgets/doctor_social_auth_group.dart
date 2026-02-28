import 'package:flutter/material.dart';

class DoctorSocialAuthGroup extends StatelessWidget {
  const DoctorSocialAuthGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Divider(color: Color(0xFFE2E8F0))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR CONTINUE WITH',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Expanded(child: Divider(color: Color(0xFFE2E8F0))),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // _buildSocialButton('assets/icons/google_logo.svg'),
            // const SizedBox(width: 20),
            // _buildSocialButton('assets/icons/apple_logo.svg'),
            // const SizedBox(width: 20),
            // _buildSocialButton('assets/icons/facebook_logo.svg'),
          ],
        ),
      ],
    );
  }

  // Widget _buildSocialButton(String assetPath) {
  //   return Container(
  //     width: 60,
  //     height: 60,
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       shape: BoxShape.circle,
  //       border: Border.all(color: const Color(0xFFE2E8F0)),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withAlpha(10),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Image.asset(
  //       assetPath,
  //       errorBuilder: (context, error, stackTrace) {
  //         return const Icon(Icons.login, color: Color(0xFF94A3B8));
  //       },
  //     ),
  //   );
  // }
}

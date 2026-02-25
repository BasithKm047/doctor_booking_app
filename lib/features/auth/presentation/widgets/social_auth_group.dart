import 'package:flutter/material.dart';

class SocialAuthGroup extends StatelessWidget {
  const SocialAuthGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(Icons.g_mobiledata, () {}),
        const SizedBox(width: 20),
        _buildSocialButton(Icons.facebook, () {}),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Icon(icon, color: const Color(0xFF1E293B), size: 30),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/otp_input_field.dart';

class VerificationSection extends StatelessWidget {
  final ValueNotifier<bool> forceOtpValidationNotifier;

  const VerificationSection({
    super.key,
    required this.forceOtpValidationNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDivider('VERIFICATION CODE'),
        const SizedBox(height: 40),
        const Text(
          'Enter 6-digit OTP',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.medConnectTitle,
          ),
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder<bool>(
          valueListenable: forceOtpValidationNotifier,
          builder: (context, forceValidation, child) {
            return OtpInputField(forceValidation: forceValidation);
          },
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              'Resend Code',
              style: TextStyle(
                color: Color(0xFF1D4ED8),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(String text) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF94A3B8),
              letterSpacing: 1.2,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
      ],
    );
  }
}

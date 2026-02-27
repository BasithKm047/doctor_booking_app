import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/core/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import '../widgets/auth_text_field.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormFieldState> mobileFieldKey;
  final TextEditingController mobileController;
  final VoidCallback onSendOtp;

  const LoginForm({
    super.key,
    required this.mobileFieldKey,
    required this.mobileController,
    required this.onSendOtp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthTextField(
          formFieldKey: mobileFieldKey,
          controller: mobileController,
          label: 'Mobile Number',
          hintText: '+1 (555) 000-0000',
          prefixIcon: Icons.smartphone,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your mobile number';
            }
            // Exactly 10 digits
            if (!RegExp(r'^\d{10}$').hasMatch(value)) {
              return 'Please enter a valid 10-digit mobile number';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        AppPrimaryButton(
          text: 'Send OTP',
          onPressed: onSendOtp,
          icon: Icons.play_arrow,
          backgroundColor: AppColors.medConnectPrimary,
          width: double.infinity,
          // height: 50,
        ),
      ],
    );
  }
}

import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'doctor_auth_text_field.dart';

class DoctorLoginForm extends StatefulWidget {
  final GlobalKey<FormFieldState> emailFieldKey;
  final TextEditingController emailController;
  final GlobalKey<FormFieldState> passwordFieldKey;
  final TextEditingController passwordController;

  const DoctorLoginForm({
    super.key,
    required this.emailFieldKey,
    required this.emailController,
    required this.passwordFieldKey,
    required this.passwordController,
  });

  @override
  State<DoctorLoginForm> createState() => _DoctorLoginFormState();
}

class _DoctorLoginFormState extends State<DoctorLoginForm> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthTextField(
          formFieldKey: widget.emailFieldKey,
          controller: widget.emailController,
          label: 'Email Address',
          hintText: 'doctor@example.com',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          formFieldKey: widget.passwordFieldKey,
          controller: widget.passwordController,
          label: 'Password',
          hintText: '••••••••',
          prefixIcon: Icons.lock_outline,
          isPassword: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: AppColors.medConnectSubtitle,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'doctor_auth_text_field.dart';

// ignore: must_be_immutable
class DoctorLoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const DoctorLoginForm({
    required this.passwordController,
    required this.emailController,
    super.key,
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
          controller: widget.emailController,
          label: 'Email Address',
          hintText: 'doctor@example.com',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email required';
            }

            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

            if (!emailRegex.hasMatch(value.trim())) {
              return 'Enter valid email';
            }

            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: widget.passwordController,
          label: 'Password',
          hintText: 'Enter your password',
          prefixIcon: Icons.lock_outline,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password required';
            }

            if (value.length < 6) {
              return 'Minimum 6 characters required';
            }

            return null;
          },
        ),
      ],
    );
  }
}

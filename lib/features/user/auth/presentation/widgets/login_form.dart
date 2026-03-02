import 'package:flutter/material.dart';
import '../widgets/auth_text_field.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormFieldState> mobileFieldKey;
  final TextEditingController mobileController;

  const LoginForm({
    super.key,
    required this.mobileFieldKey,
    required this.mobileController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthTextField(
          formFieldKey: mobileFieldKey,
          controller: mobileController,
          label: 'Mobile Number',
          hintText: 'e.g. 9876543210',
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
      ],
    );
  }
}

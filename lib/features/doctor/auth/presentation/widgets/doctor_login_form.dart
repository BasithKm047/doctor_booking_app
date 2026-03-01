import 'package:flutter/material.dart';
import 'doctor_auth_text_field.dart';

class DoctorLoginForm extends StatefulWidget {
  final TextEditingController emailController;

  const DoctorLoginForm({
    super.key,
    required this.emailController,
  });

  @override
  State<DoctorLoginForm> createState() => _DoctorLoginFormState();
}

class _DoctorLoginFormState extends State<DoctorLoginForm> {

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
      
      ],
    );
  }
}

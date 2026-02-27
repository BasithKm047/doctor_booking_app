import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/core/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import '../widgets/doctor_auth_toggle_section.dart';
import '../widgets/doctor_login_form.dart';
import '../widgets/doctor_login_header.dart';
import '../widgets/doctor_social_auth_group.dart';

// Assuming there's a doctor dashboard or home, using ChatPage as placeholder if needed
import 'package:doctor_booking_app/features/user/chat/presentation/pages/chat_page.dart';

class DoctorLoginPage extends StatefulWidget {
  final bool isInitialLogin;
  const DoctorLoginPage({super.key, this.isInitialLogin = true});

  @override
  State<DoctorLoginPage> createState() => _DoctorLoginPageState();
}

class _DoctorLoginPageState extends State<DoctorLoginPage> {
  late final ValueNotifier<bool> _isLoginNotifier;
  final _formKey = GlobalKey<FormState>();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isLoginNotifier = ValueNotifier<bool>(widget.isInitialLogin);
  }

  @override
  void dispose() {
    _isLoginNotifier.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    _isLoginNotifier.value = !_isLoginNotifier.value;
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      // In a real app, perform email/password auth here
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ChatPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // User requested white theme
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60), // Space for top balance
                  DoctorLoginHeader(isLoginNotifier: _isLoginNotifier),
                  const SizedBox(height: 24),
                  DoctorLoginForm(
                    emailFieldKey: _emailFieldKey,
                    emailController: _emailController,
                    passwordFieldKey: _passwordFieldKey,
                    passwordController: _passwordController,
                  ),
                  const SizedBox(height: 40),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isLoginNotifier,
                    builder: (context, isLogin, child) {
                      return AppPrimaryButton(
                        text: isLogin ? 'Sign In' : 'Sign Up',
                        onPressed: _signIn,
                        backgroundColor:
                            AppColors.medConnectPrimary, // Custom for doctor
                        width: double.infinity,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  DoctorAuthToggleSection(
                    isLoginNotifier: _isLoginNotifier,
                    onToggle: _toggleAuthMode,
                  ),
                  const SizedBox(height: 40),
                  const DoctorSocialAuthGroup(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

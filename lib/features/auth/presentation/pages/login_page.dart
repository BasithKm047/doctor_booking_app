import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../widgets/auth_toggle_section.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';
import '../widgets/social_auth_group.dart';
import '../widgets/verification_section.dart';

import 'package:doctor_booking_app/features/chat/presentation/pages/chat_page.dart';

class LoginPage extends StatefulWidget {
  final bool isInitialLogin;
  const LoginPage({super.key, this.isInitialLogin = true});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final ValueNotifier<bool> _isLoginNotifier;
  final _formKey = GlobalKey<FormState>();
  final _mobileFieldKey = GlobalKey<FormFieldState>();
  final TextEditingController _mobileController = TextEditingController();
  late final ValueNotifier<bool> _forceOtpValidationNotifier;

  @override
  void initState() {
    super.initState();
    _isLoginNotifier = ValueNotifier<bool>(widget.isInitialLogin);
    _forceOtpValidationNotifier = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _isLoginNotifier.dispose();
    _mobileController.dispose();
    _forceOtpValidationNotifier.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    _isLoginNotifier.value = !_isLoginNotifier.value;
  }

  void _sendOtp() {
    if (_mobileFieldKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatPage()),
      );
    }
  }

  void _signIn() {
    _forceOtpValidationNotifier.value = true;
    if (_formKey.currentState!.validate()) {
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   // child: _buildBackButton(),
                // ),
                const SizedBox(height: 32),
                LoginHeader(isLoginNotifier: _isLoginNotifier),
                const SizedBox(height: 48),
                LoginForm(
                  mobileFieldKey: _mobileFieldKey,
                  mobileController: _mobileController,
                  onSendOtp: _sendOtp,
                ),
                const SizedBox(height: 40),
                VerificationSection(
                  forceOtpValidationNotifier: _forceOtpValidationNotifier,
                ),
                const SizedBox(height: 32),
                ValueListenableBuilder<bool>(
                  valueListenable: _isLoginNotifier,
                  builder: (context, isLogin, child) {
                    return AppPrimaryButton(
                      text: isLogin ? 'Sign In' : 'Sign Up',
                      onPressed: _signIn,
                      backgroundColor: AppColors.medConnectPrimary,
                    );
                  },
                ),
                const SizedBox(height: 32),
                AuthToggleSection(
                  isLoginNotifier: _isLoginNotifier,
                  onToggle: _toggleAuthMode,
                ),
                const SizedBox(height: 40),
                const SocialAuthGroup(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

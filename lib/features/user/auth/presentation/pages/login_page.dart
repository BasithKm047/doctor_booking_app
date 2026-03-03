import 'dart:async';
import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/core/widgets/app_primary_button.dart';
import 'package:doctor_booking_app/core/widgets/custom_snack_bar.dart';
import 'package:doctor_booking_app/features/doctor/auth/presentation/pages/doctor_login_page.dart';
import 'package:doctor_booking_app/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:doctor_booking_app/features/user/home/presentation/pages/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';
import '../widgets/social_auth_group.dart';
import '../widgets/verification_section.dart';

class LoginPage extends StatefulWidget {
  final bool isInitialLogin;
  const LoginPage({super.key, this.isInitialLogin = true});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String enteredOtp = '';
  bool _isVerifying = false;

  bool _isOtpSent = false;
  int _secondsRemaining = 0;
  Timer? _timer;

  final _formKey = GlobalKey<FormState>();
  final _mobileFieldKey = GlobalKey<FormFieldState>();
  final TextEditingController _mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Reset OTP state if phone number changes
    _mobileController.addListener(() {
      if (_isOtpSent) {
        setState(() {
          _isOtpSent = false;
          _secondsRemaining = 0;
          enteredOtp = '';
        });
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // 🔹 Start 30s resend timer
  void _startResendTimer() {
    _secondsRemaining = 30;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  // 🔹 Send OTP
  void _sendOtp() {
    FocusScope.of(context).unfocus();

    if (_mobileFieldKey.currentState!.validate()) {
      String raw = _mobileController.text.trim();
      final phone = raw.startsWith('+') ? raw : '+91$raw';

      context.read<AuthBloc>().add(SentOtpEvent(phone));
      _startResendTimer();
    }
  }

  // 🔹 Verify OTP
  void _verifyOtp() {
    if (enteredOtp.length != 6) {
      CustomSnackBar.show(context, 'Please enter a 6-digit OTP', isError: true);
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() {
      _isVerifying = true;
    });

    String raw = _mobileController.text.trim();
    final phone = raw.startsWith('+') ? raw : '+91$raw';

    context.read<AuthBloc>().add(VerifyOtpEvent(phone, enteredOtp));
  }

  // 🔹 Auto verify when OTP length == 6
  void _onOtpChanged(String otp) {
    enteredOtp = otp;

    if (otp.length == 6 && !_isVerifying) {
      _verifyOtp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpSent) {
          setState(() {
            _isOtpSent = true;
          });
          CustomSnackBar.show(context, 'OTP sent successfully!');
        } else if (state is AuthVerified) {
          _isVerifying = false;
          CustomSnackBar.show(context, 'Login completed successfully!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainWrapper(),
            ),
          );
        } else if (state is AuthError) {
          setState(() {
            _isVerifying = false;
          });
          CustomSnackBar.show(
            context,
            'Error: ${state.message}',
            isError: true,
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.medConnectBackground,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),

                      // Doctor Register
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DoctorLoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Register as Doctor',
                            style: TextStyle(
                              color: AppColors.medConnectPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 26),
                      const LoginHeader(),
                      const SizedBox(height: 12),

                      // Mobile Field
                      LoginForm(
                        mobileFieldKey: _mobileFieldKey,
                        mobileController: _mobileController,
                      ),

                      // OTP Section + Resend
                      if (_isOtpSent) ...[
                        const SizedBox(height: 18),
                        VerificationSection(onOtpChanged: _onOtpChanged),
                        const SizedBox(height: 10),
                        Center(
                          child: _secondsRemaining > 0
                              ? Text(
                                  'Resend OTP in $_secondsRemaining seconds',
                                  style: TextStyle(color: Colors.grey.shade600),
                                )
                              : TextButton(
                                  onPressed: _sendOtp,
                                  child: const Text(
                                    'Resend OTP',
                                    style: TextStyle(
                                      color: AppColors.medConnectPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Toggle Button
                      AppPrimaryButton(
                        text: _isOtpSent
                            ? (_isVerifying ? 'Verifying...' : 'Verify & Login')
                            : 'Send OTP',
                        onPressed: _isVerifying
                            ? null
                            : (_isOtpSent ? _verifyOtp : _sendOtp),
                        backgroundColor: AppColors.medConnectPrimary,
                        width: double.infinity,
                      ),

                      const SizedBox(height: 20),
                      const SocialAuthGroup(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

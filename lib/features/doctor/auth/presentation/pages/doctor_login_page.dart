import 'package:doctor_booking_app/core/widgets/custom_snack_bar.dart';
import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/core/widgets/app_primary_button.dart';
import 'package:doctor_booking_app/features/doctor/home_screen/presentation/pages/doctor_main_wrapper.dart';
import 'package:doctor_booking_app/features/doctor/auth/presentation/bloc/doctor_auth_bloc.dart';
import 'package:doctor_booking_app/features/doctor/registeration/presentation/pages/doctor_registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/doctor_login_form.dart';
import '../widgets/doctor_login_header.dart';
import '../widgets/doctor_social_auth_group.dart';

class DoctorLoginPage extends StatefulWidget {
  const DoctorLoginPage({super.key});

  @override
  State<DoctorLoginPage> createState() => _DoctorLoginPageState();
}

class _DoctorLoginPageState extends State<DoctorLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isSignUp = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (isSignUp) {
      context.read<DoctorAuthBloc>().add(DoctorSignUpEvent(email, password));
    } else {
      context.read<DoctorAuthBloc>().add(DoctorLoginEvent(email, password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorAuthBloc, DoctorAuthState>(
      listener: (context, state) {
        if (state is DoctorAuthLoading) {
          CustomSnackBar.show(
            context,
            isSignUp ? "Creating account..." : "Checking login status...",
          );
        }

        if (state is DoctorAuthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DoctorMainWrapper()),
          );
        }
        if (state is DoctorAuthNewUser) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DoctorRegistrationPage()),
          );
        }
        if (state is DoctorAuthError) {
          CustomSnackBar.show(context, state.message, isError: true);
        }
      },
      builder: (context, state) {
        final isLoading = state is DoctorAuthLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    DoctorLoginHeader(),
                    const SizedBox(height: 24),
                    DoctorLoginForm(
                      emailController: _emailController,
                      passwordController: _passwordController,
                    ),
                    const SizedBox(height: 40),
                    AppPrimaryButton(
                      text: isSignUp ? 'Sign Up' : 'Login',
                      width: double.infinity,
                      backgroundColor: AppColors.medConnectPrimary,
                      onPressed: isLoading ? null : () => _submit(),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isSignUp
                              ? "Already have an account? "
                              : "New to MedConnect? ",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignUp = !isSignUp;
                            });
                          },
                          child: Text(
                            isSignUp ? "Sign In" : "Sign Up",
                            style: const TextStyle(
                              color: AppColors.medConnectPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    const DoctorSocialAuthGroup(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/core/widgets/app_primary_button.dart';
import 'package:doctor_booking_app/features/doctor/auth/presentation/bloc/docto_auth_bloc.dart';
import 'package:doctor_booking_app/features/doctor/home_screen/presentation/pages/doctor_main_wrapper.dart';
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

  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    context.read<DoctorAuthBloc>().add(SendMagicLinkEvent(email));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorAuthBloc, DoctorAuthState>(
      listener: (context, state) {
        if (state is MagicLinkSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Check your email for login link.")),
          );
          
        }
        if (state is DoctorAuthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DoctorMainWrapper()),
          );
        }
        if (state is DoctorAuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
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
                    ),

                    const SizedBox(height: 40),

                    AppPrimaryButton(
                      text: 'Send Login Link',
                      width: double.infinity,
                      backgroundColor: AppColors.medConnectPrimary,
                      onPressed: isLoading ? null : () => _submit(),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : null,
                    ),

                    const SizedBox(height: 24),

                    // DoctorAuthToggleSection(
                    //   isLoginNotifier: _isLoginNotifier,
                    //   onToggle: () =>
                    //       _isLoginNotifier.value = !_isLoginNotifier.value,
                    // ),

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

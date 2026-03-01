import 'package:doctor_booking_app/features/doctor/auth/presentation/pages/doctor_login_page.dart';
import 'package:doctor_booking_app/features/doctor/doctor_splash/presantation/bloc/doctor_splash_bloc.dart';
import 'package:doctor_booking_app/features/doctor/doctor_splash/presantation/widgets/doctor_brand_header.dart';
import 'package:doctor_booking_app/features/doctor/doctor_splash/presantation/widgets/doctor_brand_logo.dart';
import 'package:doctor_booking_app/features/doctor/doctor_splash/presantation/widgets/doctor_splash_footer.dart';
import 'package:doctor_booking_app/features/doctor/home_screen/presentation/pages/doctor_main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_loading_indicator.dart';

class DoctorSplashScreen extends StatefulWidget {
  const DoctorSplashScreen({super.key});

  @override
  State<DoctorSplashScreen> createState() => _DoctorSplashScreenState();
}

class _DoctorSplashScreenState extends State<DoctorSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    context.read<DoctorSplashBloc>().add(CheckDoctorAuthEvent());
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<DoctorSplashBloc, DoctorSplashState>(
      listener: (context, state) async{
         await Future.delayed(const Duration(seconds: 2));
        if (state is DoctorLoggedIn) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DoctorMainWrapper()),
          );
        } else if (state is DoctorNotLoggedIn) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DoctorLoginPage()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const DoctorBrandLogo(),
                    const SizedBox(height: 32),
                    const DoctorBrandHeader(
                      title: 'HealthCare',
                      subtitle: 'Your health, our priority.',
                    ),
                    const SizedBox(height: 48),
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, _) {
                        return AppLoadingIndicator(
                          progress: _progressAnimation.value,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: DoctorSplashFooter(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:doctor_booking_app/features/user/home/presentation/pages/home_screen.dart';
import 'package:doctor_booking_app/features/user/home/presentation/pages/main_wrapper.dart';
import 'package:doctor_booking_app/features/user/splash/presentation/bloc/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_loading_indicator.dart';
import '../../../start/presentation/pages/start_page.dart';
import '../widgets/brand_header.dart';
import '../widgets/brand_logo.dart';
import '../widgets/splash_footer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(CheckAuthEvent());
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

    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is UserLoggedIn) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainWrapper()),
          );
        } else if (state is UserNotLoggedIn) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const StartPage()),
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
                    const BrandLogo(),
                    const SizedBox(height: 32),
                    const BrandHeader(
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
                child: SplashFooter(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

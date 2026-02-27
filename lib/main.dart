import 'package:doctor_booking_app/features/user/splash/presentation/pages/splash_screen.dart';
import "package:flutter/material.dart";
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Booking App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // For now, let's keep it on system theme, but it will default to light
      // as per your main color preference.
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}

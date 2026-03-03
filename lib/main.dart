import 'package:doctor_booking_app/core/di/injection.dart';
import 'package:doctor_booking_app/features/doctor/appointment/presantation/bloc/doctor_appointments_bloc.dart';
import 'package:doctor_booking_app/features/doctor/auth/presentation/bloc/doctor_auth_bloc.dart';
import 'package:doctor_booking_app/features/doctor/profile/presantation/bloc/profile_bloc.dart';
import 'package:doctor_booking_app/features/doctor/registeration/presentation/bloc/doctor_bloc.dart';
import 'package:doctor_booking_app/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:doctor_booking_app/core/splash/presentation/bloc/splash_bloc.dart';
import 'package:doctor_booking_app/core/splash/presentation/pages/splash_screen.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qtsilrnrwxcmnhrxicfc.supabase.co',
    anonKey: 'sb_publishable_WucbG2CxAGFhuy6KOODNRw_tLDWqWO6',
  );

  await setupInjection();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<SplashBloc>()),
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => sl<DoctorAppointmentsBloc>()),
        BlocProvider(create: (context) => sl<DoctorAuthBloc>()),
        BlocProvider(create: (context) => sl<DoctorBloc>()),
        BlocProvider(create: (context) => sl<ProfileBloc>()),
      ],

      child: MaterialApp(
        // navigatorKey: navigatorKey,
        title: 'Doctor Booking App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        // For now, let's keep it on system theme, but it will default to light
        // as per your main color preference.
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
}

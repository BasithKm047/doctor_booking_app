import 'package:doctor_booking_app/core/di/injection.dart';
import 'package:doctor_booking_app/core/service/client.dart';
import 'package:doctor_booking_app/features/doctor/auth/presentation/bloc/docto_auth_bloc.dart';
import 'package:doctor_booking_app/features/doctor/doctor_splash/presantation/bloc/doctor_splash_bloc.dart';
import 'package:doctor_booking_app/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:doctor_booking_app/features/user/splash/presentation/bloc/splash_bloc.dart';
import 'package:doctor_booking_app/features/user/splash/presentation/pages/splash_screen.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'dart:developer' as developer;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qtsilrnrwxcmnhrxicfc.supabase.co',
    anonKey: 'sb_publishable_WucbG2CxAGFhuy6KOODNRw_tLDWqWO6',
  );
  supabase.auth.onAuthStateChange.listen((data) async {
  final event = data.event;

  if (event == AuthChangeEvent.signedIn) {
    Logger().i("Magic link login success");
  }
});

  

  developer.log('Supabase initialized successfully', name: 'main',error: null, stackTrace: null,level: 1000,sequenceNumber: null,time: DateTime.now(), zone: null);



  await setupInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<SplashBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<AuthBloc>(),
        ),

        BlocProvider(
          create: (context) => sl<DoctorAuthBloc>(),
        ),

         BlocProvider(
          create: (context) => sl<DoctorSplashBloc>(),
        ),
      ],
      
    
      child: MaterialApp(
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

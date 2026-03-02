import 'package:doctor_booking_app/core/service/app_logger.dart';
import 'package:doctor_booking_app/core/service/client.dart';
import 'package:doctor_booking_app/features/doctor/auth/data/model/doctor_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorAuthRemoteDataSource {
  Future<void> login(String email, String password) async {
    try {
      AppLogger.info('Attempting login for doctor: $email');
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        AppLogger.warning('Login failed for doctor: $email');
        throw Exception('Invalid email or password');
      }
      AppLogger.info('Login successful for doctor: $email');
    } on AuthException catch (e) {
      AppLogger.warning('Auth error for doctor: $email - ${e.message}');
      if (e.message.toLowerCase().contains('invalid login credentials')) {
        throw Exception('you are not signup please register');
      }
      throw Exception(e.message);
    }
  }

  Future<void> signUp(String email, String password) async {
    AppLogger.info('Attempting signUp for doctor: $email');
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      AppLogger.warning('SignUp failed for doctor: $email');
      throw Exception('Registration failed');
    }

    AppLogger.info('SignUp successful. Creating profile for doctor: $email');

    // Create a profile record for the doctor
    await supabase.from('profiles').insert({
      'id': response.user!.id,
      'email': email,
      'role': 'doctor',
      'created_at': DateTime.now().toIso8601String(),
    });

    AppLogger.info('Profile created successfully for doctor: $email');
  }

  Future<DoctorModel?> getCurrentUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      AppLogger.debug('No current user session found');
      return null;
    }

    AppLogger.info('Fetching profile for doctor ID: ${user.id}');

    final profile = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    if (profile['role'] != 'doctor') {
      AppLogger.warning('User ${user.id} is not a doctor');
      throw Exception('Unauthorized: Not a doctor account');
    }

    AppLogger.info('Profile fetched successfully for doctor ID: ${user.id}');

    return DoctorModel.fromMap(profile);
  }

  Future<void> signOut() async {
    AppLogger.info('Doctor signing out');
    await supabase.auth.signOut();
  }
}

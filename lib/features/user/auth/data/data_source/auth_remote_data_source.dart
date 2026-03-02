import 'package:doctor_booking_app/core/service/client.dart';
import 'package:doctor_booking_app/features/user/auth/data/models/user_model.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSource {
  Future<void> sentOtp(String phone) async {
    try {
      await supabase.auth.signInWithOtp(phone: phone);
      Logger().i("OTP sent to $phone");
    } catch (e) {
      Logger().e("Failed to send OTP: ${e.toString()}");
      throw Exception(e.toString());
    }
  }

Future<UserModel> verifyOtp(String phone, String otp) async {
  try {
    final formattedPhone = phone.startsWith('+')
        ? phone
        : '+91$phone';

    final response = await supabase.auth.verifyOTP(
      token: otp,
      phone: formattedPhone,
      type: OtpType.sms,
    );

    final user = response.user;
    if (user == null) throw Exception("User null");

    final existing = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (existing == null) {
      await supabase.from('profiles').insert({
        'id': user.id,
        'phone':  user.phone,
        'role': 'user',
      });
    }

    final profile = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    return UserModel.fromMap(profile);
  } catch (e) {
    throw Exception("Verify OTP Failed: ${e.toString()}");
  }
}

  bool isLoggedIn() {
    return supabase.auth.currentUser != null;
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    Logger().i("CURRENT USER AFTER LOGOUT: ${supabase.auth.currentUser}");
  }
}

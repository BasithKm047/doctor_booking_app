import 'package:doctor_booking_app/core/service/client.dart';
import 'package:doctor_booking_app/features/user/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSource {
  Future<void> sentOtp(String phone) async {
    try {
      await supabase.auth.signInWithOtp(phone: phone);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserModel> verifyOtp(String phone, String otp) async {
    try {
      final response = await supabase.auth.verifyOTP(
        token: otp,
        phone: phone,
        type: OtpType.sms,
      );
      final user = response.user;
      if (user == null) throw Exception("User null");
      final existing=await supabase.from('profiles').select().eq('id', user.id).maybeSingle();
     if(existing==null){
       await supabase.from('profiles').insert({
        'id': user.id,
        'phone': phone,
        'role': 'user', // default only for first time
      });
     }
      final profile=await supabase.from('profiles').select().eq('id', user.id).single();
      return UserModel.fromMap(profile);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  bool isLoggedIn() {
    return supabase.auth.currentUser != null;
  }
}

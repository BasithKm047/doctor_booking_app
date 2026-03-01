import 'package:doctor_booking_app/core/service/client.dart';
import 'package:doctor_booking_app/features/doctor/auth/data/model/doctor_model.dart';

class DoctorAuthRemoteDataSource {
 Future<void> sendMagicLink(String email) async {
    await supabase.auth.signInWithOtp(
      email: email,
      emailRedirectTo: 'io.supabase.flutterquickstart://login-callback',
    );
  }


 Future<DoctorModel?> getCurrentUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    await supabase.from('profiles').upsert({
      'id': user.id,
      'email': user.email,
    });

    final profile = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    return DoctorModel.fromMap(profile);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

 
}

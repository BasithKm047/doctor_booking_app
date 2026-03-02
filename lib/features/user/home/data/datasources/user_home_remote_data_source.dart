import 'package:doctor_booking_app/core/service/client.dart';
import '../models/user_doctor_model.dart';

class UserHomeRemoteDataSource {
  Future<List<UserDoctorModel>> getDoctors() async {
    final response = await supabase.from('doctors').select();
    return (response as List)
        .map((json) => UserDoctorModel.fromJson(json))
        .toList();
  }
}

import 'dart:io';

import 'package:doctor_booking_app/core/service/app_logger.dart';
import 'package:doctor_booking_app/core/service/client.dart';
import 'package:doctor_booking_app/features/doctor/registeration/data/model/doctor_model.dart';

class DoctorRemoteDataSource {
  Future<String?> uploadImage(String? imagePath) async {
    if (imagePath == null ||
        imagePath.isEmpty ||
        imagePath.startsWith('http')) {
      return imagePath;
    }

    try {
      final file = File(imagePath);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabase.storage.from('doctor_app').upload(fileName, file);

      final publicUrl = supabase.storage
          .from('doctor_app')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      AppLogger.error('Error uploading image: $e');
      return imagePath; // Return original path if upload fails
    }
  }

  Future<void> addDoctor(DoctorModel doctor) async {
    final uploadedImageUrl = await uploadImage(doctor.profileImage);
    final updatedDoctor = doctor.copyWith(profileImage: uploadedImageUrl);

    await supabase.from('doctors').insert(updatedDoctor.toJson());
    AppLogger.info('Doctor added successfully: ${updatedDoctor.name}');
  }

  Future<DoctorModel?> getDoctorById(String id) async {
    final response = await supabase
        .from('doctors')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return DoctorModel.fromJson(response);
  }

  Future<void> updateDoctor(DoctorModel doctor) async {
    final uploadedImageUrl = await uploadImage(doctor.profileImage);
    final updatedDoctor = doctor.copyWith(profileImage: uploadedImageUrl);

    await supabase
        .from('doctors')
        .update(updatedDoctor.toJson())
        .eq('id', updatedDoctor.id);
    AppLogger.info('Doctor updated successfully: ${updatedDoctor.name}');
  }

  Future<void> deleteDoctor(String id) async {
    await supabase.from('doctors').delete().eq('id', id);
    AppLogger.info('Doctor deleted successfully: $id');
  }

  Future<List<DoctorModel>> getDoctors() async {
    final response = await supabase.from('doctors').select();
    AppLogger.info('Doctors fetched successfully');
    return (response as List).map((e) => DoctorModel.fromJson(e)).toList();
  }
}

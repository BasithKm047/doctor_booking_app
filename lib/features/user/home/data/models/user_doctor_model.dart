import '../../domain/entities/user_doctor_entity.dart';

class UserDoctorModel extends UserDoctorEntity {
  UserDoctorModel({
    required super.id,
    required super.name,
    super.profileImage,
    required super.specialization,
    required super.experience,
    required super.consultationFee,
    required super.bio,
  });

  factory UserDoctorModel.fromJson(Map<String, dynamic> json) {
    return UserDoctorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profile_image'],
      specialization: json['specialization'] ?? 'General',
      experience: json['experience'] ?? 0,
      consultationFee: (json['consultation_fee'] as num?)?.toDouble() ?? 0.0,
      bio: json['bio'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_image': profileImage,
      'specialization': specialization,
      'experience': experience,
      'consultation_fee': consultationFee,
      'bio': bio,
    };
  }
}

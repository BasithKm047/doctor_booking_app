import '../../domain/entities/doctor_registration_entity.dart';

class DoctorModel extends DoctorRegistrationEntity {
  DoctorModel({
    required super.id,
    required super.name,
    super.profileImage,
    required super.specialization,
    required super.experience,
    required super.consultationFee,
    required super.bio,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      name: json['name'],
      profileImage: json['profile_image'],
      specialization: json['specialization'],
      experience: json['experience'],
      consultationFee: (json['consultation_fee'] as num).toDouble(),
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_image': profileImage,
      'specialization': specialization,
      'experience': experience,
      'consultation_fee': consultationFee.toInt(),
      'bio': bio,
    };
  }

  // copywith
  DoctorModel copyWith({
    String? id,
    String? name,
    String? profileImage,
    String? specialization,
    int? experience,
    double? consultationFee,
    String? bio,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      specialization: specialization ?? this.specialization,
      experience: experience ?? this.experience,
      consultationFee: consultationFee ?? this.consultationFee,
      bio: bio ?? this.bio,
    );
  }
}

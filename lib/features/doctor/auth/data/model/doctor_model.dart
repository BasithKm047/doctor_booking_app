import 'package:doctor_booking_app/features/doctor/auth/domain/entities/doctor_entity.dart';

class DoctorModel  extends DoctorEntity{
    DoctorModel({
    required super.id,
    required super.email,
    required super.role,
  });


  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'],
      email: map['email'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'role': role,
    };
  }

  //copywith
  DoctorModel copyWith({
    String? id,
    String? email,
    String? role,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }
  
}
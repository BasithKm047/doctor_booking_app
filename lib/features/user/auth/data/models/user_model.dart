import '../../domain/entities/user_entitt.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.role,
    super.phone,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      role: map['role'],
      phone: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'role': role,
      'phone': phone,
    };
  }
}
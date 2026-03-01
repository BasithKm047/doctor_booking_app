class UserEntity {
  final String id;
  final String role;
  final String? phone;

  UserEntity({
    required this.id,
    required this.role,
    this.phone,
  });
}
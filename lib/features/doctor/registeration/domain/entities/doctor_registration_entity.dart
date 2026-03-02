class DoctorRegistrationEntity  {
  final String id;
  final String name;
  final String? profileImage;
  final String specialization;
  final int experience;
  final double consultationFee;
  final String bio;

  DoctorRegistrationEntity({
    required this.id,
    required this.name,
    this.profileImage,
    required this.specialization,
    required this.experience,
    required this.consultationFee,
    required this.bio,
  });
}
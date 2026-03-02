class UserDoctorEntity {
  final String id;
  final String name;
  final String? profileImage;
  final String specialization;
  final int experience;
  final double consultationFee;
  final String bio;

  final String hospital;
  final double rating;
  final int reviews;
  final String nextAvailable;

  UserDoctorEntity({
    required this.id,
    required this.name,
    this.profileImage,
    required this.specialization,
    required this.experience,
    required this.consultationFee,
    required this.bio,
    this.hospital = 'MedConnect Center',
    this.rating = 4.8,
    this.reviews = 120,
    this.nextAvailable = 'Available Today',
  });
}

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final double rating;
  final int reviews;
  final String nextAvailable;
  final String imagePath;

  final String about;
  final String experience;
  final double fee;

  final int availabilitySlots;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.rating,
    required this.reviews,
    required this.nextAvailable,
    required this.imagePath,
    required this.about,
    required this.experience,
    required this.fee,
    this.availabilitySlots = 4,
  });
}

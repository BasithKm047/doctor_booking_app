class Appointment {
  final String id;
  final String doctorId;
  final String doctorName;
  final String specialty;
  final String date;
  final String time;
  final String imagePath;
  final bool isUpcoming;
  final String status;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.imagePath,
    this.isUpcoming = true,
    this.status = 'pending',
  });
}

class UserAppointmentEntity {
  final String? id;
  final String userId;
  final String doctorId;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String description;
  final String patientName;
  final String? patientImage;
  final String location;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserAppointmentEntity({
    this.id,
    required this.userId,
    required this.doctorId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.description,
    required this.patientName,
    this.patientImage,
    required this.location,
    this.createdAt,
    this.updatedAt,
  });
}

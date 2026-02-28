class DoctorRequest {
  final String id;
  final String patientName;
  final String appointmentType;
  final String patientImageUrl;
  final DateTime appointmentTime;
  final bool isNew;

  const DoctorRequest({
    required this.id,
    required this.patientName,
    required this.appointmentType,
    required this.patientImageUrl,
    required this.appointmentTime,
    this.isNew = false,
  });
}

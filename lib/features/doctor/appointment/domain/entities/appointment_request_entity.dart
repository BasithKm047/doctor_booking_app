enum AppointmentStatus { pending, confirmed, past }

class AppointmentRequest {
  final String id;
  final String patientName;
  final String patientId;
  final String? patientImageUrl;
  final DateTime appointmentTime;
  final String appointmentType;
  final String? note;
  final bool isNew;
  final AppointmentStatus status;

  const AppointmentRequest({
    required this.id,
    required this.patientName,
    required this.patientId,
    this.patientImageUrl,
    required this.appointmentTime,
    required this.appointmentType,
    this.note,
    this.isNew = false,
    this.status = AppointmentStatus.pending,
  });
}

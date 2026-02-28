import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/features/doctor/appointment/domain/entities/appointment_request_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentRequestCard extends StatelessWidget {
  final AppointmentRequest request;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const AppointmentRequestCard({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPending = request.status == AppointmentStatus.pending;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.medConnectPrimary.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: request.patientImageUrl != null
                            ? Image.asset(
                                request.patientImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.person,
                                      color: AppColors.medConnectPrimary,
                                      size: 30,
                                    ),
                              )
                            : const Icon(
                                Icons.person,
                                color: AppColors.medConnectPrimary,
                                size: 30,
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                request.patientName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.medConnectTitle,
                                ),
                              ),
                              if (request.isNew)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.medConnectPrimary
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'NEW REQUEST',
                                    style: TextStyle(
                                      color: AppColors.medConnectPrimary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          // Text(
                          //   'Patient ID: #${request.patientId}',
                          //   style: const TextStyle(
                          //     fontSize: 13,
                          //     color: AppColors.medConnectSubtitle,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  Icons.calendar_today_outlined,
                  '${_getFormattedDate(request.appointmentTime)} • ${DateFormat('hh:mm a').format(request.appointmentTime)}',
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.local_hospital_outlined,
                  request.appointmentType,
                ),
                if (request.note != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.medConnectBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '"${request.note}"',
                      style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: AppColors.medConnectTitle,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isPending)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(  
                    onPressed: onDecline,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.redAccent),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12)),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: Colors.redAccent,
                    ),
                    child: const Text(
                      'Decline',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.medConnectPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Accept Appointment',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.medConnectTitle),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.medConnectTitle,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Today, ${DateFormat('MMM dd').format(date)}';
    } else if (dateToCheck == tomorrow) {
      return 'Tomorrow, ${DateFormat('MMM dd').format(date)}';
    } else {
      return DateFormat('EEE, MMM dd').format(date);
    }
  }
}

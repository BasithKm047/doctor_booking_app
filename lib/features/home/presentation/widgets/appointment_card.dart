import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/appointment.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  appointment.imagePath,
                  height: 100,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctorName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment.specialty,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(),
          const SizedBox(height: 16),
          _buildActionRow(),
        ],
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      children: [
        Icon(Icons.calendar_today, size: 16, color: Color(0xFF64748B)),
        const SizedBox(width: 8),
        Text(
          appointment.date,
          style: const TextStyle(fontSize: 14, color: Color(0xFF475569)),
        ),
        const SizedBox(width: 8),
        const CircleAvatar(radius: 2, backgroundColor: Color(0xFFCBD5E1)),
        const SizedBox(width: 8),
        Icon(Icons.access_time, size: 16, color: Color(0xFF64748B)),
        const SizedBox(width: 8),
        Text(
          appointment.time,
          style: const TextStyle(fontSize: 14, color: Color(0xFF475569)),
        ),
      ],
    );
  }

  Widget _buildActionRow() {
    return Row(
      children: [
        Expanded(
          child: _buildButton(
            'Reschedule',
            AppColors.medConnectPrimary,
            Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildButton(
            'Cancel',
            const Color(0xFFF8FAFC),
            const Color(0xFF475569),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

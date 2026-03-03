import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../home/domain/models/appointment.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;
  final bool showActions;
  final String? statusLabel;
  final Color? statusColor;
  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onReschedule,
    this.onCancel,
    this.showActions = true,
    this.statusLabel,
    this.statusColor,
  });

  Widget _buildDoctorImage() {
    final path = appointment.imagePath.trim();
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        height: 100,
        width: 80,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackImage(),
      );
    }
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        height: 100,
        width: 80,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackImage(),
      );
    }
    return Image.file(
      File(path),
      height: 100,
      width: 80,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallbackImage(),
    );
  }

  Widget _fallbackImage() {
    return Container(
      height: 100,
      width: 80,
      color: const Color(0xFFF1F5F9),
      child: const Icon(Icons.person, color: Color(0xFF64748B)),
    );
  }

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
                borderRadius: BorderRadius.circular(14),
                child: _buildDoctorImage(),
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
          if (showActions) _buildActionRow() else _buildStatusChip(),
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
            onTap: onReschedule,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildButton(
            'Cancel',
            const Color(0xFFDC2626),
            Colors.white,
            onTap: onCancel,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip() {
    final label = statusLabel ?? 'Past';
    final color = statusColor ?? const Color(0xFF64748B);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    String text,
    Color bgColor,
    Color textColor, {
    VoidCallback? onTap,
  }) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

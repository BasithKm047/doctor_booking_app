import 'package:flutter/material.dart';
import '../../domain/entities/user_doctor_entity.dart';

class DoctorDetailsHeader extends StatelessWidget {
  final UserDoctorEntity doctor;

  const DoctorDetailsHeader({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child:
                    doctor.profileImage != null &&
                        doctor.profileImage!.isNotEmpty
                    ? Image.network(
                        doctor.profileImage!,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.person,
                              size: 120,
                              color: Colors.grey,
                            ),
                      )
                    : const Icon(Icons.person, size: 120, color: Colors.grey),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          doctor.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          doctor.specialization,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E5BB1),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${doctor.experience} experience • CBT Specialist',
          style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                Icons.star,
                'RATING',
                '${doctor.rating}/5',
                const Color(0xFF1E5BB1),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
                Icons.payments_outlined,
                'FEE',
                '\$${doctor.consultationFee.toInt()}/hr',
                const Color(0xFF1E5BB1),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}

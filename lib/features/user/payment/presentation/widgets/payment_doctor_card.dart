import 'package:flutter/material.dart';
import '../../../home/domain/entities/user_doctor_entity.dart';

class PaymentDoctorCard extends StatelessWidget {
  final UserDoctorEntity doctor;

  const PaymentDoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'APPOINTMENT DETAILS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E5BB1),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  doctor.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${doctor.specialization} • ${doctor.hospital} • ${doctor.experience} Years Exp.',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEFF6FF),
                      foregroundColor: const Color(0xFF1E5BB1),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'View Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child:
                (doctor.profileImage != null &&
                    doctor.profileImage!.isNotEmpty &&
                    doctor.profileImage!.startsWith('http'))
                ? Image.network(
                    doctor.profileImage!,
                    height: 90,
                    width: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 90,
                      width: 72,
                      color: Colors.grey[200],
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                  )
                : Image.asset(
                    'assets/images/doctor_image_1.png',
                    height: 90,
                    width: 72,
                    fit: BoxFit.cover,
                  ),
          ),
        ],
      ),
    );
  }
}

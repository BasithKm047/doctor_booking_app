import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/models/doctor.dart';
import '../pages/doctor_details_screen.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final bool isDark;

  const DoctorCard({super.key, required this.doctor, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDark
        ? AppColors.medConnectPrimary.withValues(alpha: .7)
        : const Color(0xFFF1F5F9);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subTextColor = isDark ? Colors.white70 : const Color(0xFF64748B);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(32),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Doctor Image - Placed on the right
          Positioned(
            right: -5,
            bottom: 70, // Adjusted to sit at the bottom or slightly offset
            child: Image.asset(
              doctor.imagePath,
              height: 180,
              width: 180,
              fit: BoxFit.contain,
            ),
          ),
    
          // Content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badges
                Row(
                  children: [
                    _buildBadge(
                      Icons.star,
                      doctor.rating.toString(),
                      isDark ? Colors.white : const Color(0xFF1E293B),
                      const Color(0xFFFACC15),
                      isDark,
                    ),
                    const SizedBox(width: 12),
                    _buildBadge(
                      Icons.monetization_on,
                      "\$${doctor.fee.toInt()}/hr",
                      isDark ? Colors.white : const Color(0xFF1E293B),
                      const Color(0xFF22C55E),
                      isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
    
                // Doctor Name & Specialty
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Text(
                    doctor.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.specialty,
                  style: TextStyle(
                    fontSize: 16,
                    color: subTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
    
                // Book Now Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DoctorDetailsScreen(doctor: doctor),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.white
                        : AppColors.medConnectPrimary,
                    foregroundColor: isDark
                        ? AppColors.medConnectPrimary
                        : Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(
    IconData icon,
    String text,
    Color textColor,
    Color iconColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

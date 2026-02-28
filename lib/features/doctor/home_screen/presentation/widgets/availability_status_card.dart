import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AvailabilityStatusCard extends StatefulWidget {
  const AvailabilityStatusCard({super.key});

  @override
  State<AvailabilityStatusCard> createState() => _AvailabilityStatusCardState();
}

class _AvailabilityStatusCardState extends State<AvailabilityStatusCard> {
  bool _isAvailable = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.medConnectBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_today_outlined,
              color: Colors.redAccent,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Availability Status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.medConnectTitle,
                  ),
                ),
                Text(
                  _isAvailable
                      ? 'Currently accepting appointments'
                      : 'Not accepting appointments',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.medConnectSubtitle,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isAvailable,
            onChanged: (value) {
              setState(() {
                _isAvailable = value;
              });
            },
            activeColor: Colors.white,
            activeTrackColor: AppColors.medConnectPrimary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColors.medConnectDotInactive,
          ),
        ],
      ),
    );
  }
}

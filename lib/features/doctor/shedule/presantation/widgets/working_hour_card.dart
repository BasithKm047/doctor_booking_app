import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/features/doctor/shedule/domain/entities/availability_day_entity.dart';
import 'package:flutter/material.dart';

class WorkingHourCard extends StatelessWidget {
  final AvailabilityDay day;
  final ValueChanged<bool?> onToggle;

  const WorkingHourCard({super.key, required this.day, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: day.isActive
            ? Colors.white
            : AppColors.medConnectBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: day.isActive
              ? Colors.black.withOpacity(0.05)
              : Colors.transparent,
        ),
        boxShadow: day.isActive
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  checkColor: AppColors.lightOnPrimary,
                  value: day.isActive,
                  onChanged: onToggle,
                  activeColor: AppColors.medConnectSubtitle.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.medConnectPrimary),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                day.dayName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: day.isActive
                      ? AppColors.medConnectTitle
                      : AppColors.medConnectSubtitle,
                ),
              ),
              const Spacer(),
              Text(
                day.isActive ? 'Active' : 'Off Day',
                style: TextStyle(
                  fontSize: 12,
                  color: day.isActive
                      ? AppColors.medConnectSubtitle
                      : AppColors.medConnectSubtitle.withOpacity(0.5),
                ),
              ),
            ],
          ),
          if (day.isActive) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTimeField(Icons.login, day.startTime)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'to',
                    style: TextStyle(color: AppColors.medConnectSubtitle),
                  ),
                ),
                Expanded(child: _buildTimeField(Icons.logout, day.endTime)),
              ],
            ),
            if (day.isHalfDay) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.info,
                    size: 14,
                    color: AppColors.medConnectPrimary,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Half day selected',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.medConnectPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildTimeField(IconData icon, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.medConnectBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.medConnectTitle.withOpacity(0.6),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.medConnectTitle,
            ),
          ),
        ],
      ),
    );
  }
}

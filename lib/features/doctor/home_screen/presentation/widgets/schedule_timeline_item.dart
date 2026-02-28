import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/features/doctor/home_screen/domain/entities/schedule_item_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleTimelineItem extends StatelessWidget {
  final ScheduleItem item;
  final bool isLast;

  const ScheduleTimelineItem({
    super.key,
    required this.item,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              child: Column(
                children: [
                  Text(
                    DateFormat('HH:mm').format(item.time),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: item.isHighPriority
                          ? AppColors.medConnectPrimary
                          : AppColors.medConnectTitle.withOpacity(0.8),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 1,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        color: Colors.grey.shade200,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: item.isHighPriority
                      ? AppColors.medConnectPrimary.withOpacity(0.08)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: item.isHighPriority
                      ? const Border(
                          left: BorderSide(
                            color: AppColors.medConnectPrimary,
                            width: 4,
                          ),
                        )
                      : Border.all(color: Colors.grey.shade100),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.medConnectTitle,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.location,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.medConnectSubtitle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (item.isHighPriority)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.medConnectPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 16,
                        ),
                      )
                    else
                      const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

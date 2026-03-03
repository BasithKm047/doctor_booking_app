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

  Color get _statusColor {
    switch (item.status) {
      case ScheduleStatus.confirmed:
        return Colors.green;
      case ScheduleStatus.pending:
        return Colors.orange;
    }
  }

  String get _statusText {
    switch (item.status) {
      case ScheduleStatus.confirmed:
        return 'CONFIRMED';
      case ScheduleStatus.pending:
        return 'PENDING';
    }
  }

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
                      color: _statusColor,
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
                  color: _statusColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border(
                    left: BorderSide(color: _statusColor, width: 4),
                  ),
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
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _statusText,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (item.status == ScheduleStatus.confirmed)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _statusColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      )
                    else
                      Icon(Icons.schedule, color: _statusColor, size: 20),
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

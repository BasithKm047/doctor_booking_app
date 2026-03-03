import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorAvailabilityPicker extends StatefulWidget {
  final List<Map<String, dynamic>> availability;
  final Function(DateTime date, String time) onSlotSelected;

  const DoctorAvailabilityPicker({
    super.key,
    required this.availability,
    required this.onSlotSelected,
  });

  @override
  State<DoctorAvailabilityPicker> createState() =>
      _DoctorAvailabilityPickerState();
}

class _DoctorAvailabilityPickerState extends State<DoctorAvailabilityPicker> {
  int selectedDateIndex = -1;
  int selectedTimeIndex = -1;

  List<DateTime> availableDates = [];
  Map<DateTime, List<_TimeSlot>> dateToTimes = {};

  static const Duration _slotInterval = Duration(minutes: 30);

  @override
  void initState() {
    super.initState();
    _parseAvailability();
  }

  @override
  void didUpdateWidget(covariant DoctorAvailabilityPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.availability != oldWidget.availability) {
      _parseAvailability();
    }
  }

  void _parseAvailability() {
    availableDates.clear();
    dateToTimes.clear();
    selectedDateIndex = -1;
    selectedTimeIndex = -1;

    for (var slot in widget.availability) {
      final rawDate = slot['available_date'];
      final rawStart = slot['start_time'];
      final rawEnd = slot['end_time'];

      if (rawDate == null || rawStart == null || rawEnd == null) {
        continue;
      }

      final dateStr = rawDate is String ? rawDate : rawDate.toString();
      final startStr = rawStart is String ? rawStart : rawStart.toString();
      final endStr = rawEnd is String ? rawEnd : rawEnd.toString();

      final date = DateTime.parse(dateStr);
      final normalizedDate = DateTime(date.year, date.month, date.day);

      if (!availableDates.contains(normalizedDate)) {
        availableDates.add(normalizedDate);
        dateToTimes[normalizedDate] = [];
      }

      final slots = _buildSlotsForRange(startStr, endStr);
      dateToTimes[normalizedDate]!.addAll(slots);
    }

    // Select first date automatically if available
    if (availableDates.isNotEmpty) {
      setState(() {
        selectedDateIndex = 0;
      });
    }
  }

  List<_TimeSlot> _buildSlotsForRange(String startStr, String endStr) {
    final startMinutes = _tryParseTimeToMinutes(startStr);
    final endMinutes = _tryParseTimeToMinutes(endStr);
    if (startMinutes == null || endMinutes == null) return const [];

    // Guard: invalid/empty ranges
    if (endMinutes <= startMinutes) return const [];

    final slots = <_TimeSlot>[];
    for (int m = startMinutes; m < endMinutes; m += _slotInterval.inMinutes) {
      final value = _minutesToTimeValue(m);
      final display = _minutesToDisplay(m);
      slots.add(_TimeSlot(value: value, display: display));
    }
    return slots;
  }

  int? _tryParseTimeToMinutes(String raw) {
    // Expected from backend: HH:mm:ss (we also handle HH:mm)
    final parts = raw.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return hour * 60 + minute;
  }

  String _minutesToTimeValue(int minutes) {
    final hour = (minutes ~/ 60).clamp(0, 23);
    final minute = (minutes % 60).clamp(0, 59);
    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    return '$hh:$mm:00';
  }

  String _minutesToDisplay(int minutes) {
    final hour = (minutes ~/ 60).clamp(0, 23);
    final minute = (minutes % 60).clamp(0, 59);
    final dt = DateTime(2023, 1, 1, hour, minute);
    return DateFormat('hh:mm a').format(dt);
  }

  void _onSelectionChanged() {
    if (selectedDateIndex != -1 &&
        selectedTimeIndex != -1 &&
        dateToTimes[availableDates[selectedDateIndex]] != null) {
      final date = availableDates[selectedDateIndex];
      final slot = dateToTimes[date]![selectedTimeIndex];
      widget.onSlotSelected(date, slot.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (availableDates.isEmpty) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Dates',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              'No availability found for this doctor.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      );
    }

    List<_TimeSlot> currentTimes = [];
    if (selectedDateIndex != -1 && selectedDateIndex < availableDates.length) {
      currentTimes = dateToTimes[availableDates[selectedDateIndex]] ?? [];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Dates',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: availableDates.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _buildDateCard(index),
          ),
        ),
        const SizedBox(height: 24),
        if (currentTimes.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemCount: currentTimes.length,
            itemBuilder: (context, index) =>
                _buildTimeCard(index, currentTimes[index]),
          )
        else
          const Center(
            child: Text(
              'No times available for this date.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
      ],
    );
  }

  Widget _buildDateCard(int index) {
    bool isSelected = selectedDateIndex == index;
    final date = availableDates[index];
    final dayStr = DateFormat('EEE').format(date);
    final dateStr = DateFormat('dd').format(date);

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDateIndex = index;
          selectedTimeIndex = -1; // Reset time when date changes
        });
        _onSelectionChanged();
      },
      child: Container(
        width: 60,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.medConnectPrimary
                : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayStr,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? AppColors.medConnectPrimary
                    : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dateStr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? AppColors.medConnectPrimary
                    : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCard(int index, _TimeSlot slot) {
    bool isSelected = selectedTimeIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTimeIndex = index;
        });
        _onSelectionChanged();
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.medConnectPrimary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          slot.display,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ),
    );
  }
}

class _TimeSlot {
  final String value; // HH:mm:ss (for backend/storage)
  final String display; // hh:mm a (for UI)

  const _TimeSlot({required this.value, required this.display});
}

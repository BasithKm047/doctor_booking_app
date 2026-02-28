class AvailabilityDay {
  final String dayName;
  final String shortDayName;
  final bool isActive;
  final String startTime;
  final String endTime;
  final bool isHalfDay;

  const AvailabilityDay({
    required this.dayName,
    required this.shortDayName,
    this.isActive = false,
    this.startTime = '09:00 AM',
    this.endTime = '05:00 PM',
    this.isHalfDay = false,
  });

  AvailabilityDay copyWith({
    bool? isActive,
    String? startTime,
    String? endTime,
    bool? isHalfDay,
  }) {
    return AvailabilityDay(
      dayName: dayName,
      shortDayName: shortDayName,
      isActive: isActive ?? this.isActive,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isHalfDay: isHalfDay ?? this.isHalfDay,
    );
  }
}

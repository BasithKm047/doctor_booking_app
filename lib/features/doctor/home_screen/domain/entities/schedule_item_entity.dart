class ScheduleItem {
  final String id;
  final DateTime time;
  final String title;
  final String location;
  final bool isHighPriority;

  const ScheduleItem({
    required this.id,
    required this.time,
    required this.title,
    required this.location,
    this.isHighPriority = false,
  });
}

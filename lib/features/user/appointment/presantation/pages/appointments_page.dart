import 'package:doctor_booking_app/core/di/injection.dart';
import 'package:doctor_booking_app/core/widgets/custom_snack_bar.dart';
import 'package:doctor_booking_app/features/user/appointment/domain/repositories/user_appointment_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../home/domain/entities/user_doctor_entity.dart';
import '../../../home/domain/models/appointment.dart';
import '../../../home/presentation/pages/appointment_booking_screen.dart';
import '../widgets/appointment_card.dart';
import '../widgets/appointment_section_header.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  late Future<List<Appointment>> _appointmentsFuture;
  static const Duration _slotDuration = Duration(minutes: 30);

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = _loadAppointments();
  }

  Future<List<Appointment>> _loadAppointments() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return const [];

    final rows = await sl<UserAppointmentRepository>().fetchUserAppointments(
      userId,
    );
    return rows.map((item) {
      final appointmentDateTime = _parseAppointmentDateTime(
        item['appointment_date']?.toString(),
        item['appointment_time']?.toString(),
      );
      final status = (item['status'] ?? '').toString().toLowerCase();
      final isUpcoming = _isUpcomingStatus(status);

      return Appointment(
        id: item['id'].toString(),
        doctorId: item['doctor_id']?.toString() ?? '',
        doctorName: item['doctor_name']?.toString() ?? 'Doctor',
        specialty: item['doctor_specialization']?.toString() ?? 'Specialist',
        date: DateFormat('MMM dd, yyyy').format(appointmentDateTime),
        time: DateFormat('hh:mm a').format(appointmentDateTime),
        imagePath:
            item['doctor_image']?.toString() ??
            'assets/images/doctor_image_1.png',
        isUpcoming: isUpcoming,
        status: status,
      );
    }).toList()..sort((a, b) {
      final adt = _parseFromUi(a.date, a.time);
      final bdt = _parseFromUi(b.date, b.time);
      return adt.compareTo(bdt);
    });
  }

  bool _isUpcomingStatus(String status) {
    final normalized = status.toLowerCase();
    return normalized == 'pending' || normalized == 'booked';
  }

  bool _isPastStatus(String status) {
    final normalized = status.toLowerCase();
    return normalized == 'confirmed' ||
        normalized == 'rejected' ||
        normalized == 'user_cancelled' ||
        normalized == 'user_canceled' ||
        normalized == 'cancelled' ||
        normalized == 'canceled';
  }

  DateTime _parseAppointmentDateTime(String? date, String? time) {
    final safeDate = date ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
    final safeTime = (time ?? '09:00').trim();

    try {
      return DateTime.parse('$safeDate $safeTime');
    } catch (_) {
      try {
        final parsedDate = DateTime.parse(safeDate);
        final parsedTime = DateFormat('hh:mm a').parseLoose(safeTime);
        return DateTime(
          parsedDate.year,
          parsedDate.month,
          parsedDate.day,
          parsedTime.hour,
          parsedTime.minute,
        );
      } catch (_) {
        return DateTime.now();
      }
    }
  }

  DateTime _parseFromUi(String date, String time) {
    return DateFormat('MMM dd, yyyy hh:mm a').parse('$date $time');
  }

  Future<void> _cancelAppointment(Appointment appointment) async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text(
          'Are you sure you want to cancel this appointment?',
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 34,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF475569),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    minimumSize: const Size(54, 34),
                  ),
                  child: const Text('No'),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 34,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    minimumSize: const Size(72, 34),
                  ),
                  child: const Text('Yes'),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (shouldCancel != true) return;

    try {
      await sl<UserAppointmentRepository>().cancelAppointment(appointment.id);
      if (!mounted) return;
      CustomSnackBar.show(context, 'Appointment cancelled');
      await _refresh();
    } catch (_) {
      if (!mounted) return;
      CustomSnackBar.show(
        context,
        'Failed to cancel appointment',
        isError: true,
      );
    }
  }

  Future<void> _rescheduleAppointment(Appointment appointment) async {
    final action = await _showRescheduleOptions();
    if (!mounted || action == null) return;

    if (action == _RescheduleAction.openBooking) {
      _openRescheduleInBookingScreen(appointment);
      return;
    }

    final mergedDateTime = await _pickDoctorAvailableSlot(appointment);
    if (mergedDateTime == null) return;

    try {
      await sl<UserAppointmentRepository>().rescheduleAppointment(
        appointmentId: appointment.id,
        appointmentDate: DateFormat('yyyy-MM-dd').format(mergedDateTime),
        appointmentTime: DateFormat('HH:mm:ss').format(mergedDateTime),
      );
      if (!mounted) return;
      CustomSnackBar.show(context, 'Appointment rescheduled');
      await _refresh();
    } catch (_) {
      if (!mounted) return;
      CustomSnackBar.show(
        context,
        'Failed to reschedule appointment',
        isError: true,
      );
    }
  }

  Future<_RescheduleAction?> _showRescheduleOptions() {
    return showModalBottomSheet<_RescheduleAction>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.calendar_today_rounded),
                  title: const Text('Reschedule in booking screen'),
                  subtitle: const Text('Navigate and pick doctor availability'),
                  onTap: () => Navigator.pop(context, _RescheduleAction.openBooking),
                ),
                ListTile(
                  leading: const Icon(Icons.access_time_rounded),
                  title: const Text('Quick reschedule here'),
                  subtitle: const Text('Select from available date and time slots'),
                  onTap: () => Navigator.pop(context, _RescheduleAction.quickSlot),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openRescheduleInBookingScreen(Appointment appointment) {
    if (appointment.doctorId.isEmpty) {
      CustomSnackBar.show(
        context,
        'Doctor details not available for this appointment',
        isError: true,
      );
      return;
    }

    final doctor = UserDoctorEntity(
      id: appointment.doctorId,
      name: appointment.doctorName,
      profileImage: appointment.imagePath,
      specialization: appointment.specialty,
      experience: 0,
      consultationFee: 0,
      bio: '',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentBookingScreen(doctor: doctor),
      ),
    );
  }

  Future<DateTime?> _pickDoctorAvailableSlot(Appointment appointment) async {
    if (appointment.doctorId.isEmpty) {
      CustomSnackBar.show(
        context,
        'Doctor availability not found',
        isError: true,
      );
      return null;
    }

    try {
      final availability = await sl<UserAppointmentRepository>()
          .fetchDoctorAvailability(appointment.doctorId);
      final slots = _expandSlots(availability);
      if (!mounted) return null;

      if (slots.isEmpty) {
        CustomSnackBar.show(
          context,
          'No available slots for this doctor',
          isError: true,
        );
        return null;
      }

      return showModalBottomSheet<DateTime>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    'Select New Time',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.separated(
                      itemCount: slots.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final slot = slots[index];
                        return ListTile(
                          title: Text(DateFormat('EEE, MMM dd, yyyy').format(slot)),
                          subtitle: Text(DateFormat('hh:mm a').format(slot)),
                          onTap: () => Navigator.pop(context, slot),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (_) {
      if (!mounted) return null;
      CustomSnackBar.show(
        context,
        'Failed to load doctor availability',
        isError: true,
      );
      return null;
    }
  }

  List<DateTime> _expandSlots(List<Map<String, dynamic>> availability) {
    final now = DateTime.now();
    final List<DateTime> slots = [];

    for (final item in availability) {
      final dateText = item['available_date']?.toString();
      final startText = item['start_time']?.toString();
      final endText = item['end_time']?.toString();
      if (dateText == null || startText == null || endText == null) continue;

      final day = DateTime.tryParse(dateText);
      final start = _parseTimeOfDay(startText);
      final end = _parseTimeOfDay(endText);
      if (day == null || start == null || end == null) continue;

      var cursor = DateTime(day.year, day.month, day.day, start.hour, start.minute);
      final endDateTime = DateTime(day.year, day.month, day.day, end.hour, end.minute);

      while (cursor.isBefore(endDateTime) || cursor.isAtSameMomentAs(endDateTime)) {
        if (cursor.isAfter(now)) {
          slots.add(cursor);
        }
        cursor = cursor.add(_slotDuration);
      }
    }

    slots.sort((a, b) => a.compareTo(b));
    return slots;
  }

  TimeOfDay? _parseTimeOfDay(String value) {
    try {
      final parsed = DateTime.parse('2000-01-01 ${value.trim()}');
      return TimeOfDay(hour: parsed.hour, minute: parsed.minute);
    } catch (_) {
      try {
        final parsed = DateFormat('hh:mm a').parseLoose(value.trim());
        return TimeOfDay(hour: parsed.hour, minute: parsed.minute);
      } catch (_) {
        return null;
      }
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _appointmentsFuture = _loadAppointments();
    });
    await _appointmentsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: const Text(
            'Appointments',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Color(0xFF1E293B),
            indicatorWeight: 3,
            labelColor: Color(0xFF1E293B),
            unselectedLabelColor: Color(0xFF94A3B8),
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: FutureBuilder<List<Appointment>>(
          future: _appointmentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Failed to load appointments',
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _refresh,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final allAppointments = snapshot.data ?? const [];
            final upcoming = allAppointments
                .where((a) => _isUpcomingStatus(a.status))
                .toList();
            final past = allAppointments
                .where((a) => _isPastStatus(a.status))
                .toList();

            return TabBarView(
              children: [
                _buildAppointmentList(
                  appointments: upcoming,
                  emptyText: 'No upcoming appointments',
                  showActions: true,
                ),
                _buildAppointmentList(
                  appointments: past,
                  emptyText: 'No past appointments',
                  showActions: false,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppointmentList({
    required List<Appointment> appointments,
    required String emptyText,
    required bool showActions,
  }) {
    if (appointments.isEmpty) {
      return Center(child: Text(emptyText));
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const AppointmentSectionHeader(title: 'Your Appointments'),
          ...appointments.map(
            (item) => AppointmentCard(
              appointment: item,
              showActions: showActions,
              statusLabel: _statusLabel(item.status),
              statusColor: _statusColor(item.status),
              onCancel: showActions ? () => _cancelAppointment(item) : null,
              onReschedule: showActions
                  ? () => _rescheduleAppointment(item)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'rejected':
        return 'Rejected';
      case 'user_cancelled':
      case 'user_canceled':
      case 'cancelled':
      case 'canceled':
        return 'User Canceled';
      case 'confirmed':
        return 'Approved';
      case 'past':
        return 'Completed';
      case 'booked':
      case 'pending':
      default:
        return 'Pending';
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'rejected':
        return const Color(0xFFDC2626);
      case 'user_cancelled':
      case 'user_canceled':
      case 'cancelled':
      case 'canceled':
        return const Color(0xFFEA580C);
      case 'confirmed':
        return const Color(0xFF16A34A);
      case 'past':
        return const Color(0xFF64748B);
      case 'booked':
      case 'pending':
      default:
        return const Color(0xFFF59E0B);
    }
  }
}

enum _RescheduleAction { openBooking, quickSlot }

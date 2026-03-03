import 'dart:io';

import 'package:doctor_booking_app/features/doctor/appointment/domain/entities/appointment_request_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorNotificationsPage extends StatefulWidget {
  final List<AppointmentRequest> notifications;

  const DoctorNotificationsPage({super.key, required this.notifications});

  @override
  State<DoctorNotificationsPage> createState() =>
      _DoctorNotificationsPageState();
}

class _DoctorNotificationsPageState extends State<DoctorNotificationsPage> {
  late List<AppointmentRequest> _items;
  final Set<String> _deletedIds = <String>{};

  @override
  void initState() {
    super.initState();
    _items = List<AppointmentRequest>.from(widget.notifications);
  }

  Widget _buildPatientImage(String? imagePath) {
    if (imagePath == null || imagePath.trim().isEmpty) {
      return const Icon(Icons.person, color: Colors.white, size: 20);
    }
    final normalized = imagePath.trim();
    if (normalized.startsWith('http://') || normalized.startsWith('https://')) {
      return Image.network(
        normalized,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.person, color: Colors.white, size: 20),
      );
    }
    if (normalized.startsWith('assets/')) {
      return Image.asset(
        normalized,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.person, color: Colors.white, size: 20),
      );
    }
    return Image.file(
      File(normalized),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.person, color: Colors.white, size: 20),
    );
  }

  void _deleteNotification(String id) {
    setState(() {
      _deletedIds.add(id);
      _items.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _deletedIds.toList());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Notifications'), centerTitle: true),
        body: _items.isEmpty
            ? const Center(
                child: Text(
                  'No new notifications',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFF2563EB),
                          child: ClipOval(
                            child: SizedBox(
                              width: 36,
                              height: 36,
                              child: _buildPatientImage(item.patientImageUrl),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'New appointment from ${item.patientName}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat(
                                  'MMM dd, yyyy • hh:mm a',
                                ).format(item.appointmentTime),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _deleteNotification(item.id),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemCount: _items.length,
              ),
      ),
    );
  }
}

import 'dart:io';
import 'package:doctor_booking_app/core/widgets/custom_snack_bar.dart';
import 'package:doctor_booking_app/features/user/appointment/domain/repositories/user_appointment_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/user_doctor_entity.dart';
import '../../../../../core/theme/app_colors.dart';
import '../widgets/doctor_availability_picker.dart';
import '../widgets/doctor_location_card.dart';
import '../widgets/doctor_details_header.dart';
import 'package:doctor_booking_app/features/user/appointment/domain/entities/user_appointment_entity.dart';
import 'package:doctor_booking_app/features/user/appointment/presantation/bloc/booking_bloc.dart';
import 'package:doctor_booking_app/features/user/appointment/presantation/bloc/booking_event.dart';
import 'package:doctor_booking_app/features/user/appointment/presantation/bloc/booking_state.dart';
import 'package:doctor_booking_app/core/di/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../payment/presentation/pages/payment_page.dart';

class AppointmentBookingScreen extends StatefulWidget {
  final UserDoctorEntity doctor;
  final String? rescheduleAppointmentId;

  const AppointmentBookingScreen({
    super.key,
    required this.doctor,
    this.rescheduleAppointmentId,
  });

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _patientProblemController =
      TextEditingController();
  File? _patientImage;
  bool _isLocationSelected = false;
  DateTime? _selectedDate;
  String? _selectedTime;

  bool get _isRescheduleFlow => widget.rescheduleAppointmentId != null;

  @override
  void initState() {
    super.initState();
    if (_isRescheduleFlow) {
      _isLocationSelected = true;
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _patientImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isRescheduleFlow ? 'Reschedule Appointment' : 'Confirm Appointment',
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) =>
            sl<BookingBloc>()..add(FetchAvailabilityEvent(widget.doctor.id)),
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  DoctorDetailsHeader(doctor: widget.doctor),
                  const SizedBox(height: 32),
                  const Text(
                    'Patient Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: _patientImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.file(
                                    _patientImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Color(0xFF94A3B8),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _patientNameController,
                          decoration: InputDecoration(
                            hintText: 'Patient Full Name',
                            hintStyle: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  if (state is AvailabilityLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.medConnectPrimary,
                      ),
                    )
                  else if (state is AvailabilityLoaded)
                    DoctorAvailabilityPicker(
                      availability: state.availability,
                      onSlotSelected: (date, time) {
                        setState(() {
                          _selectedDate = date;
                          _selectedTime = time;
                        });
                      },
                    )
                  else if (state is AvailabilityError)
                    Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isLocationSelected = !_isLocationSelected;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: _isLocationSelected
                              ? AppColors.medConnectSubtitle
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: const DoctorLocationCard(),
                    ),
                  ),

                  SizedBox(height: 12),

                  const Text(
                    'Tell the doctor about your problem',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.medConnectPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _patientProblemController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText:
                          'Enter your symptoms or any specific concerns here...',
                      hintStyle: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      if (!_isRescheduleFlow &&
                          _patientNameController.text.isEmpty) {
                        CustomSnackBar.show(
                          context,
                          'Please enter patient name',
                        );
                        return;
                      }
                      if (!_isLocationSelected) {
                        CustomSnackBar.show(
                          context,
                          'Please select the clinic location',
                        );
                        return;
                      }
                      if (_selectedDate == null || _selectedTime == null) {
                        CustomSnackBar.show(
                          context,
                          'Please select an appointment date and time',
                        );
                        return;
                      }

                      final currentUser =
                          Supabase.instance.client.auth.currentUser;
                      if (currentUser == null) {
                        CustomSnackBar.show(
                          context,
                          'You must be logged in to book an appointment',
                        );
                        return;
                      }

                      if (_isRescheduleFlow) {
                        _submitReschedule();
                        return;
                      }

                      final appointment = UserAppointmentEntity(
                        userId: currentUser.id,
                        doctorId: widget.doctor.id,
                        appointmentDate: _selectedDate!,
                        appointmentTime: _selectedTime!,
                        description: _patientProblemController.text,
                        patientName: _patientNameController.text,
                        patientImage: _patientImage
                            ?.path, // Store local path for now, handle upload later if needed
                        location:
                            "Dummy Location", // Or fetch from the location card properly
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                            doctor: widget.doctor,
                            appointment: appointment,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.medConnectPrimary,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 4,
                      shadowColor: AppColors.medConnectPrimary.withOpacity(0.4),
                    ),
                    child: Text(
                      _isRescheduleFlow
                          ? 'Update Appointment'
                          : 'Review Payment',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _submitReschedule() async {
    final appointmentId = widget.rescheduleAppointmentId;
    if (appointmentId == null || _selectedDate == null || _selectedTime == null) {
      return;
    }

    try {
      await sl<UserAppointmentRepository>().rescheduleAppointment(
        appointmentId: appointmentId,
        appointmentDate: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        appointmentTime: _selectedTime!,
      );
      if (!mounted) return;
      CustomSnackBar.show(context, 'Appointment rescheduled');
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      CustomSnackBar.show(
        context,
        'Failed to reschedule appointment',
        isError: true,
      );
    }
  }
}

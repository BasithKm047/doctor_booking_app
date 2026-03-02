import 'dart:io';
import 'package:doctor_booking_app/core/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/user_doctor_entity.dart';
import '../../../../../core/theme/app_colors.dart';
import '../widgets/doctor_availability_picker.dart';
import '../widgets/doctor_location_card.dart';
import '../widgets/doctor_details_header.dart';
import '../../../payment/presentation/pages/payment_page.dart';

class AppointmentBookingScreen extends StatefulWidget {
  final UserDoctorEntity doctor;

  const AppointmentBookingScreen({super.key, required this.doctor});

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _patientProblemController = TextEditingController();
  File? _patientImage;
  bool _isLocationSelected = false;
  String _selectedDate = "Oct 13, 2023"; // Dummy default matching picker
  String _selectedTime = "10:30 AM"; // Dummy default matching picker

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
        title: const Text(
          'Confirm Appointment',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
            const DoctorAvailabilityPicker(),
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

            SizedBox(height: 12,),

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
                if (_patientNameController.text.isEmpty) {
                  CustomSnackBar.show(context, 'Please enter patient name');
                  return;
                }
                if (!_isLocationSelected) {
                  CustomSnackBar.show(
                    context,
                    'Please select the clinic location',
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(
                      doctor: widget.doctor,
                      // Note: We'll update PaymentPage constructor next to handle these
                      // patientName: _patientNameController.text,
                      // location: "Malappuram, Tirurangadi, Kerala",
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
              child: const Text(
                'Review Payment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

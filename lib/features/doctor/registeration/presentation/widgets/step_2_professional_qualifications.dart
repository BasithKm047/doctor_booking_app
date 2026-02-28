import 'package:doctor_booking_app/features/doctor/registeration/data/mock_registration_data.dart';
import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/features/doctor/auth/presentation/widgets/doctor_auth_text_field.dart';
import 'package:flutter/material.dart';

class Step2ProfessionalQualifications extends StatelessWidget {
  final TextEditingController licenseController;
  final TextEditingController schoolController;
  final int? selectedYear;
  final Function(int) onYearChanged;

  const Step2ProfessionalQualifications({
    super.key,
    required this.licenseController,
    required this.schoolController,
    this.selectedYear,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STEP 2 OF 3',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.medConnectSubtitle,
                  ),
                ),
                Text(
                  'Professional\nQualifications',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.medConnectPrimary,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  '66%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.medConnectPrimary,
                  ),
                ),
                const Text(
                  'Complete',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.medConnectPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: 0.66,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(
            AppColors.medConnectPrimary,
          ),
          borderRadius: BorderRadius.circular(10),
          minHeight: 8,
        ),
        const SizedBox(height: 32),
        // const Text(
        //   'Medical License Number',
        //   style: TextStyle(fontWeight: FontWeight.w600),
        // ),
        const SizedBox(height: 8),
        AuthTextField(
          controller: licenseController,
          label: 'Medical License Number',
          hintText: 'e.g. MLN-12345678',
          prefixIcon: Icons.badge_outlined,
        ),
        const SizedBox(height: 24),
        // const Text(
        //   'Medical School',
        //   style: TextStyle(fontWeight: FontWeight.w600),
        // ),
        const SizedBox(height: 8),
        AuthTextField(
          controller: schoolController,
          label: 'Medical School',
          hintText: 'Enter university name',
          prefixIcon: Icons.school_outlined,
        ),
        const SizedBox(height: 24),
        const Text(
          'Year of Graduation',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          isExpanded: true,
          value: selectedYear,
          decoration: InputDecoration(
            hintText: 'Select Year',
            hintStyle: const TextStyle(color: AppColors.medConnectSubtitle),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: AppColors.medConnectPrimary),
            ),
            suffixIcon: const Icon(Icons.keyboard_arrow_down),
          ),
          items: MockRegistrationData.graduationYears
              .map((y) => DropdownMenuItem(value: y, child: Text(y.toString())))
              .toList(),
          onChanged: (value) => onYearChanged(value!),
        ),
        const SizedBox(height: 24),
        const Text(
          'Upload Medical Degree/Certification',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.medConnectPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_upload,
                  color: AppColors.medConnectPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Click to upload or drag and drop',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Text(
                'PDF, JPG or PNG (max. 5MB)',
                style: TextStyle(
                  color: AppColors.medConnectPrimary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

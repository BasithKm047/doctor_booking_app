import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/features/doctor/auth/presentation/widgets/doctor_auth_text_field.dart';
import 'package:flutter/material.dart';

class Step2ProfessionalQualifications extends StatelessWidget {
  final TextEditingController feeController;
  final TextEditingController bioController;

  const Step2ProfessionalQualifications({
    super.key,
    required this.feeController,
    required this.bioController,
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
                  'STEP 2 OF 2',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.medConnectSubtitle,
                  ),
                ),
                Text(
                  'Consultation\nDetails',
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
                  '100%',
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
          value: 1.0,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(
            AppColors.medConnectPrimary,
          ),
          borderRadius: BorderRadius.circular(10),
          minHeight: 8,
        ),
        const SizedBox(height: 32),
        AuthTextField(
          controller: feeController,
          label: 'Consultation Fee',
          hintText: 'e.g. 50.00',
          prefixIcon: Icons.attach_money,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        const Text(
          'Professional Bio',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: bioController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Tell patients about your experience...',
            hintStyle: const TextStyle(color: AppColors.medConnectSubtitle),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
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
          ),
        ),
      ],
    );
  }
}

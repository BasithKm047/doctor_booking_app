import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/features/doctor/auth/presentation/widgets/doctor_auth_text_field.dart';
import 'package:flutter/material.dart';

class Step3ClinicDetails extends StatelessWidget {
  final TextEditingController clinicNameController;
  final TextEditingController addressController;
  final TextEditingController feeController;
  final TextEditingController bioController;

  const Step3ClinicDetails({
    super.key,
    required this.clinicNameController,
    required this.addressController,
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
            const Text(
              'Clinic Details & Bio',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.medConnectPrimary,
              ),
            ),
            const Text(
              'Step 3 of 3',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.medConnectSubtitle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Final step to complete your profile',
          style: TextStyle(color: AppColors.medConnectPrimary),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: 1.0,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(
            AppColors.medConnectPrimary,
          ),
          borderRadius: BorderRadius.circular(10),
          minHeight: 8,
        ),
        const SizedBox(height: 20),
        // const Text(
        //   'Clinic Name',
        //   style: TextStyle(fontWeight: FontWeight.w600),
        // ),
        const SizedBox(height: 8),
        AuthTextField(
          controller: clinicNameController,
          label: 'Clinic Name',
          hintText: 'e.g. City Wellness Center',
          prefixIcon: Icons.store_outlined,
        ),
        const SizedBox(height: 24),
        // const Text(
        //   'Clinic Address',
        //   style: TextStyle(fontWeight: FontWeight.w600),
        // ),
        const SizedBox(height: 8),
        AuthTextField(
          controller: addressController,
          label: 'Clinic Address',
          hintText: 'Enter full clinical address',
          prefixIcon: Icons.location_on_outlined,
        ),
        const SizedBox(height: 24),
        // const Text(
        //   'Consultation Fee',
        //   style: TextStyle(fontWeight: FontWeight.w600),
        // ),
        const SizedBox(height: 8),
        AuthTextField(
          controller: feeController,
          label: 'Consultation Fee',
          hintText: '0.00',
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
            hintText:
                'Tell patients about your experience, specialties, and approach to care...',
            hintStyle: const TextStyle(color: AppColors.medConnectPrimary),
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
        const SizedBox(height: 4),
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Maximum 500 characters',
            style: TextStyle(color: AppColors.medConnectPrimary, fontSize: 10),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: NetworkImage(
                'https://via.placeholder.com/400x150?text=Map+Preview',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.my_location, size: 18),
              label: const Text('Verify on map'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(150, 40),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

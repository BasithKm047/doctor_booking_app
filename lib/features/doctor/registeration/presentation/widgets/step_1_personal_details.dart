import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:doctor_booking_app/features/doctor/registeration/data/mock_registration_data.dart';
import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/features/doctor/auth/presentation/widgets/doctor_auth_text_field.dart';
import 'package:flutter/material.dart';

class Step1PersonalDetails extends StatelessWidget {
  final TextEditingController nameController;
  final String? selectedSpecialty;
  final TextEditingController experienceController;
  final Function(String) onSpecialtyChanged;
  final String? profileImageUrl;
  final void Function(String?) onPhotoChanged;
  final bool isUploading;

  const Step1PersonalDetails({
    super.key,
    required this.nameController,
    required this.experienceController,
    required this.selectedSpecialty,
    required this.onSpecialtyChanged,
    required this.profileImageUrl,
    required this.onPhotoChanged,
    this.isUploading = false,
  });

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      onPhotoChanged(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 1: Personal Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.medConnectPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Please provide your basic information to set up your professional profile.',
          style: TextStyle(fontSize: 14, color: AppColors.medConnectSubtitle),
        ),
        const SizedBox(height: 32),
        Center(
          child: GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: isUploading
                      ? const Center(child: CircularProgressIndicator())
                      : profileImageUrl == null
                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                      : ClipOval(
                          child: profileImageUrl!.startsWith('http')
                              ? Image.network(
                                  profileImageUrl!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.grey,
                                      ),
                                )
                              : Image.file(
                                  File(profileImageUrl!),
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.medConnectPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'Upload profile photo',
            style: TextStyle(color: AppColors.medConnectSubtitle, fontSize: 12),
          ),
        ),
        const SizedBox(height: 32),
        AuthTextField(
          obscureText: false,
          controller: nameController,
          label: 'Full Name',
          hintText: 'e.g. Dr. Jane Smith',
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: 24),
        const Text(
          'Medical Specialty',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedSpecialty,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.medical_services_outlined),
            hintText: 'Select your specialty',
            hintStyle: const TextStyle(color: AppColors.medConnectSubtitle),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
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
          ),
          items: MockRegistrationData.specialties
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (value) => onSpecialtyChanged(value!),
        ),
        const SizedBox(height: 24),
        AuthTextField(
          controller: experienceController,
          label: 'Years of Experience',
          hintText: 'e.g. 10',
          prefixIcon: Icons.work_outline,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

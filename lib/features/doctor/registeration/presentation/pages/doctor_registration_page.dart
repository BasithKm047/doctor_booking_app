import 'package:doctor_booking_app/features/doctor/home_screen/presentation/pages/doctor_main_wrapper.dart';
import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/features/doctor/registeration/presentation/widgets/step_1_personal_details.dart';
import 'package:doctor_booking_app/features/doctor/registeration/presentation/widgets/step_2_professional_qualifications.dart';
import 'package:doctor_booking_app/features/doctor/registeration/presentation/widgets/step_3_clinic_details.dart';
import 'package:flutter/material.dart';

class DoctorRegistrationPage extends StatefulWidget {
  const DoctorRegistrationPage({super.key});

  @override
  State<DoctorRegistrationPage> createState() => _DoctorRegistrationPageState();
}

class _DoctorRegistrationPageState extends State<DoctorRegistrationPage> {
  int _currentStep = 1;
  bool _isLoading = false;

  // Step 1 Controllers
  final nameController = TextEditingController();
  final experienceController = TextEditingController();
  String? selectedSpecialty;
  String? selectedGender;

  // Step 2 Controllers
  final licenseController = TextEditingController();
  final schoolController = TextEditingController();
  int? selectedYear;

  // Step 3 Controllers
  final clinicNameController = TextEditingController();
  final addressController = TextEditingController();
  final feeController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    experienceController.dispose();
    licenseController.dispose();
    schoolController.dispose();
    clinicNameController.dispose();
    addressController.dispose();
    feeController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    } else {
      _finishRegistration();
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _finishRegistration() async {
    setState(() {
      _isLoading = true;
    });

    // Mock completing registration
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(8),
          content: const Text(
            'Registration Successful! (Mock)',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.medConnectPrimary,
        ),
      );
      // navigate to home Screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DoctorMainWrapper()),
        (route) => false,
      );
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Doctor Registration',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildStepContent(context, _currentStep),
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, int currentStep) {
    switch (currentStep) {
      case 1:
        return Step1PersonalDetails(
          nameController: nameController,
          experienceController: experienceController,
          selectedSpecialty: selectedSpecialty,
          selectedGender: selectedGender,
          onSpecialtyChanged: (val) => setState(() => selectedSpecialty = val),
          onGenderChanged: (val) => setState(() => selectedGender = val),
        );
      case 2:
        return Step2ProfessionalQualifications(
          licenseController: licenseController,
          schoolController: schoolController,
          selectedYear: selectedYear,
          onYearChanged: (val) => setState(() => selectedYear = val),
        );
      case 3:
        return Step3ClinicDetails(
          clinicNameController: clinicNameController,
          addressController: addressController,
          feeController: feeController,
          bioController: bioController,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (_currentStep > 1)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _previousStep,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              if (_currentStep > 1) const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.medConnectPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentStep == 3
                                  ? 'Finish Registration'
                                  : 'Continue',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _currentStep == 3
                                  ? Icons.check_circle_outline
                                  : Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _currentStep == 3
                ? 'By clicking Finish, you agree to our Medical Professional Terms of Service and Privacy Policy.'
                : 'Step $_currentStep of 3',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.medConnectPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

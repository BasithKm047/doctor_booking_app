import 'package:doctor_booking_app/core/widgets/custom_snack_bar.dart';
import 'package:doctor_booking_app/core/service/client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_booking_app/features/doctor/registeration/presentation/bloc/doctor_bloc.dart';
import 'package:doctor_booking_app/features/doctor/registeration/presentation/bloc/doctor_event.dart';
import 'package:doctor_booking_app/features/doctor/registeration/presentation/bloc/doctor_state.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/entities/doctor_registration_entity.dart';
import 'package:doctor_booking_app/features/doctor/home_screen/presentation/pages/doctor_main_wrapper.dart';
import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/features/doctor/registeration/presentation/widgets/step_1_personal_details.dart';
import 'package:doctor_booking_app/features/doctor/registeration/presentation/widgets/step_2_professional_qualifications.dart';
import 'package:flutter/material.dart';

class DoctorRegistrationPage extends StatefulWidget {
  final DoctorRegistrationEntity? doctor;
  const DoctorRegistrationPage({super.key, this.doctor});

  @override
  State<DoctorRegistrationPage> createState() => _DoctorRegistrationPageState();
}

class _DoctorRegistrationPageState extends State<DoctorRegistrationPage> {
  int _currentStep = 1;

  // Step 1 Controllers
  late final TextEditingController nameController;
  late final TextEditingController experienceController;
  String? selectedSpecialty;
  String? profileImageUrl;

  // Step 2 Controllers
  late final TextEditingController feeController;
  late final TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.doctor?.name);
    experienceController = TextEditingController(
      text: widget.doctor?.experience.toString(),
    );
    selectedSpecialty = widget.doctor?.specialization;
    profileImageUrl = widget.doctor?.profileImage;
    feeController = TextEditingController(
      text: widget.doctor?.consultationFee.toString(),
    );
    bioController = TextEditingController(text: widget.doctor?.bio);
  }

  @override
  void dispose() {
    nameController.dispose();
    experienceController.dispose();
    feeController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      if (!_validateCurrentStep()) return;
      setState(() {
        _currentStep++;
      });
    } else {
      if (!_validateCurrentStep()) return;
      _finishRegistration();
    }
  }

  bool _validateCurrentStep() {
    if (_currentStep == 1) {
      if (nameController.text.isEmpty ||
          experienceController.text.isEmpty ||
          selectedSpecialty == null) {
        CustomSnackBar.show(
          context,
          'Please fill all fields and select a specialty',
          isError: true,
        );
        return false;
      }
    } else if (_currentStep == 2) {
      if (feeController.text.isEmpty || bioController.text.isEmpty) {
        CustomSnackBar.show(context, 'Please fill all fields', isError: true);
        return false;
      }
    }
    return true;
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _finishRegistration() {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      CustomSnackBar.show(
        context,
        'User session expired. Please log in again.',
        isError: true,
      );
      return;
    }

    final doctor = DoctorRegistrationEntity(
      id: widget.doctor?.id ?? userId,
      name: nameController.text,
      specialization: selectedSpecialty ?? 'General',
      experience: int.tryParse(experienceController.text) ?? 0,
      profileImage: profileImageUrl,
      consultationFee: double.tryParse(feeController.text) ?? 0.0,
      bio: bioController.text,
    );

    if (widget.doctor != null) {
      context.read<DoctorBloc>().add(UpdateDoctorEvent(doctor));
    } else {
      context.read<DoctorBloc>().add(AddDoctorEvent(doctor));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DoctorBloc, DoctorState>(
      listener: (context, state) {
        if (state is DoctorLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );
        } else if (state is DoctorSuccess) {
          // Close loading dialog
          Navigator.of(context, rootNavigator: true).pop();

          CustomSnackBar.show(context, 'Registration Successful!');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DoctorMainWrapper()),
            (route) => false,
          );
        } else if (state is ImageUploading) {
          // No need for a global loading dialog for image upload
          // We handle it locally in Step 1
        } else if (state is ImageUploaded) {
          setState(() {
            profileImageUrl = state.url;
          });
          CustomSnackBar.show(context, 'Profile image uploaded!');
        } else if (state is DoctorError) {
          // Check if it was a registration error (dialog open) or upload error
          if (ModalRoute.of(context)?.isCurrent == false) {
            Navigator.of(context, rootNavigator: true).pop();
          }

          CustomSnackBar.show(
            context,
            'Error: ${state.message}',
            isError: true,
          );
        }
      },
      child: Scaffold(
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
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, int currentStep) {
    switch (currentStep) {
      case 1:
        final doctorState = context.watch<DoctorBloc>().state;
        return Step1PersonalDetails(
          nameController: nameController,
          experienceController: experienceController,
          selectedSpecialty: selectedSpecialty,
          onSpecialtyChanged: (val) => setState(() => selectedSpecialty = val),
          profileImageUrl: profileImageUrl,
          isUploading: doctorState is ImageUploading,
          onPhotoChanged: (path) {
            if (path != null) {
              context.read<DoctorBloc>().add(UploadImageEvent(path));
            }
          },
        );
      case 2:
        return Step2ProfessionalQualifications(
          feeController: feeController,
          bioController: bioController,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (context, state) {
        final isLoading = state is DoctorLoading;
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
                        onPressed: isLoading ? null : _previousStep,
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
                      onPressed: isLoading ? null : _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.medConnectPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
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
                                  _currentStep == 2
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
                                  _currentStep == 2
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
                _currentStep == 2
                    ? 'By clicking Finish, you agree to our Medical Professional Terms of Service and Privacy Policy.'
                    : 'Step $_currentStep of 2',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.medConnectPrimary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

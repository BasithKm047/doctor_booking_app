import 'dart:developer';

import 'package:doctor_booking_app/features/doctor/registeration/domain/entities/registration_repository.dart';

import '../../domain/doctor_registration_entity.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  @override
  Future<void> registerDoctor(DoctorRegistrationEntity registrationData) async {
    // Mocking an API call
    await Future.delayed(const Duration(seconds: 2));
    // In a real app, this would send data to a backend
    log('Doctor registered: ${registrationData.fullName}');
  }
}

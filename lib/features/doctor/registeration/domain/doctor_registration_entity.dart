import 'dart:io';

class DoctorRegistrationEntity {
  // Step 1: Personal Details
  final String? fullName;
  final String? medicalSpecialty;
  final int? yearsOfExperience;
  final String? gender;
  final File? profilePhoto;

  // Step 2: Professional Qualifications
  final String? medicalLicenseNumber;
  final String? medicalSchool;
  final int? yearOfGraduation;
  final File? medicalDegreeCertificate;

  // Step 3: Clinic Details & Bio
  final String? clinicName;
  final String? clinicAddress;
  final double? consultationFee;
  final String? professionalBio;
  final double? latitude;
  final double? longitude;

  const DoctorRegistrationEntity({
    this.fullName,
    this.medicalSpecialty,
    this.yearsOfExperience,
    this.gender,
    this.profilePhoto,
    this.medicalLicenseNumber,
    this.medicalSchool,
    this.yearOfGraduation,
    this.medicalDegreeCertificate,
    this.clinicName,
    this.clinicAddress,
    this.consultationFee,
    this.professionalBio,
    this.latitude,
    this.longitude,
  });

  DoctorRegistrationEntity copyWith({
    String? fullName,
    String? medicalSpecialty,
    int? yearsOfExperience,
    String? gender,
    File? profilePhoto,
    String? medicalLicenseNumber,
    String? medicalSchool,
    int? yearOfGraduation,
    File? medicalDegreeCertificate,
    String? clinicName,
    String? clinicAddress,
    double? consultationFee,
    String? professionalBio,
    double? latitude,
    double? longitude,
  }) {
    return DoctorRegistrationEntity(
      fullName: fullName ?? this.fullName,
      medicalSpecialty: medicalSpecialty ?? this.medicalSpecialty,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      gender: gender ?? this.gender,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      medicalLicenseNumber: medicalLicenseNumber ?? this.medicalLicenseNumber,
      medicalSchool: medicalSchool ?? this.medicalSchool,
      yearOfGraduation: yearOfGraduation ?? this.yearOfGraduation,
      medicalDegreeCertificate:
          medicalDegreeCertificate ?? this.medicalDegreeCertificate,
      clinicName: clinicName ?? this.clinicName,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      consultationFee: consultationFee ?? this.consultationFee,
      professionalBio: professionalBio ?? this.professionalBio,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

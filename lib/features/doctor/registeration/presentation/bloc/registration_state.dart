import 'package:equatable/equatable.dart';
import '../../domain/doctor_registration_entity.dart';

enum RegistrationStatus { initial, loading, success, failure }

class RegistrationState extends Equatable {
  final int currentStep;
  final DoctorRegistrationEntity registrationData;
  final RegistrationStatus status;
  final String? errorMessage;

  const RegistrationState({
    this.currentStep = 1,
    this.registrationData = const DoctorRegistrationEntity(),
    this.status = RegistrationStatus.initial,
    this.errorMessage,
  });

  RegistrationState copyWith({
    int? currentStep,
    DoctorRegistrationEntity? registrationData,
    RegistrationStatus? status,
    String? errorMessage,
  }) {
    return RegistrationState(
      currentStep: currentStep ?? this.currentStep,
      registrationData: registrationData ?? this.registrationData,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    registrationData,
    status,
    errorMessage,
  ];
}

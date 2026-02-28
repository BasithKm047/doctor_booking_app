import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/registration_repository.dart';
import 'registration_state.dart';
import '../../domain/doctor_registration_entity.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final RegistrationRepository _repository;

  RegistrationCubit(this._repository) : super(const RegistrationState());

  void updateRegistrationData(DoctorRegistrationEntity newData) {
    emit(state.copyWith(registrationData: newData));
  }

  void nextStep() {
    if (state.currentStep < 3) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    } else {
      submitRegistration();
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  Future<void> submitRegistration() async {
    emit(state.copyWith(status: RegistrationStatus.loading));
    try {
      await _repository.registerDoctor(state.registrationData);
      emit(state.copyWith(status: RegistrationStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: RegistrationStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}

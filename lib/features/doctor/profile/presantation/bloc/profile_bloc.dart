import 'package:bloc/bloc.dart';
import 'package:doctor_booking_app/features/doctor/profile/domain/usecases/get_doctor_profile.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/entities/doctor_registration_entity.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetDoctorProfile getDoctorProfile;

  ProfileBloc({required this.getDoctorProfile}) : super(ProfileInitial()) {
    on<FetchProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        final doctor = await getDoctorProfile(event.id);
        if (doctor != null) {
          emit(ProfileLoaded(doctor));
        } else {
          emit(const ProfileError('Doctor profile not found'));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}

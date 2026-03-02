import 'package:doctor_booking_app/core/service/app_logger.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/usecases/add_doctor.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/usecases/delet_doctor.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/usecases/get_doctor.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/usecases/update_doctor.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/usecases/upload_image.dart';
import 'package:doctor_booking_app/features/doctor/registeration/presentation/bloc/doctor_event.dart';
import 'package:doctor_booking_app/features/doctor/registeration/presentation/bloc/doctor_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final AddDoctor addDoctor;
  final UpdateDoctor updateDoctor;
  final GetDoctor getDoctors;
  final DeleteDoctor deleteDoctor;
  final UploadImage uploadImage;

  DoctorBloc({
    required this.addDoctor,
    required this.updateDoctor,
    required this.getDoctors,
    required this.deleteDoctor,
    required this.uploadImage,
  }) : super(DoctorInitial()) {
    on<UploadImageEvent>((event, emit) async {
      emit(ImageUploading());
      try {
        final url = await uploadImage(event.path);
        if (url != null) {
          emit(ImageUploaded(url));
        } else {
          emit(DoctorError("Failed to upload image"));
        }
      } catch (e) {
        emit(DoctorError(e.toString()));
      }
    });

    on<AddDoctorEvent>((event, emit) async {
      emit(DoctorLoading());
      try {
        await addDoctor(event.doctor);
        AppLogger.info("Doctor added successfully");
        emit(DoctorSuccess());
      } catch (e) {
        AppLogger.error("Error adding doctor: $e");
        emit(DoctorError(e.toString()));
      }
    });

    on<GetDoctorsEvent>((event, emit) async {
      try {
        final doctors = await getDoctors();
        AppLogger.info("Doctors fetched successfully");
        emit(DoctorLoaded(doctors));
      } catch (e) {
        AppLogger.error("Error fetching doctors: $e");
        emit(DoctorError(e.toString()));
      }
    });

    on<UpdateDoctorEvent>((event, emit) async {
      emit(DoctorLoading());
      try {
        await updateDoctor(event.doctor);
        AppLogger.info("Doctor updated successfully");
        emit(DoctorSuccess());
      } catch (e) {
        AppLogger.error("Error updating doctor: $e");
        emit(DoctorError(e.toString()));
      }
    });

    on<DeleteDoctorEvent>((event, emit) async {
      emit(DoctorLoading());
      try {
        await deleteDoctor(event.id);
        AppLogger.info("Doctor deleted successfully");
        emit(DoctorSuccess());
      } catch (e) {
        AppLogger.error("Error deleting doctor: $e");
        emit(DoctorError(e.toString()));
      }
    });
  }
}

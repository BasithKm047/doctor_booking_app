import 'package:doctor_booking_app/core/service/appointments_realtime_service.dart';
import 'package:doctor_booking_app/features/doctor/appointment/data/datasources/doctor_appointment_remote_data_source.dart';
import 'package:doctor_booking_app/features/doctor/appointment/data/repositories/doctor_appointment_repository_impl.dart';
import 'package:doctor_booking_app/features/doctor/appointment/domain/repositories/doctor_appointment_repository.dart';
import 'package:doctor_booking_app/features/doctor/appointment/domain/usecases/accept_appointment_usecase.dart';
import 'package:doctor_booking_app/features/doctor/appointment/domain/usecases/get_doctor_appointments_usecase.dart';
import 'package:doctor_booking_app/features/doctor/appointment/domain/usecases/reject_appointment_usecase.dart';
import 'package:doctor_booking_app/features/doctor/appointment/presantation/bloc/doctor_appointments_bloc.dart';
import 'package:doctor_booking_app/features/doctor/auth/data/data_source/doctor_auth_remote_data_source.dart';
import 'package:doctor_booking_app/features/doctor/auth/data/repositories/doctor_auth_repository_impl.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/repositories/doctor_auth_repository.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/usecases/doctor_is_loggedin.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/usecases/doctor_login.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/usecases/doctor_signup.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/usecases/doctor_signout.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/usecases/get_auth_doctor.dart';
import 'package:doctor_booking_app/features/doctor/auth/presentation/bloc/doctor_auth_bloc.dart';
import 'package:doctor_booking_app/features/doctor/doctor_splash/presantation/bloc/doctor_splash_bloc.dart';
import 'package:doctor_booking_app/features/doctor/registeration/data/data_source/doctor_remote_data_source.dart';
import 'package:doctor_booking_app/features/doctor/registeration/data/repositories/registration_repository_impl.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/repositories/doctor_repositories.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/usecases/add_doctor.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/usecases/delet_doctor.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/usecases/get_doctor.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/usecases/update_doctor.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/usecases/upload_image.dart';
import 'package:doctor_booking_app/features/doctor/registeration/presentation/bloc/doctor_bloc.dart';
import 'package:doctor_booking_app/features/user/auth/data/data_source/auth_remote_data_source.dart';
import 'package:doctor_booking_app/features/user/auth/data/repositories/auth_repository_impl.dart';
import 'package:doctor_booking_app/features/user/auth/domain/repositories/auth_repositories.dart';
import 'package:doctor_booking_app/features/user/auth/domain/usecase/is_logged_in.dart';
import 'package:doctor_booking_app/features/user/auth/domain/usecase/sendotp.dart';
import 'package:doctor_booking_app/features/user/auth/domain/usecase/signout.dart';
import 'package:doctor_booking_app/features/user/auth/domain/usecase/verifyotp.dart';
import 'package:doctor_booking_app/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:doctor_booking_app/features/user/chat/presentation/bloc/chat_bloc.dart';
import 'package:doctor_booking_app/features/user/home/data/datasources/user_home_remote_data_source.dart';
import 'package:doctor_booking_app/features/user/home/data/repositories/user_home_repository_impl.dart';
import 'package:doctor_booking_app/features/user/home/domain/repositories/user_home_repository.dart';
import 'package:doctor_booking_app/features/user/home/domain/usecases/get_user_doctors.dart';
import 'package:doctor_booking_app/features/user/home/presentation/bloc/user_home_bloc.dart';
import 'package:doctor_booking_app/features/doctor/profile/domain/usecases/get_doctor_profile.dart';
import 'package:doctor_booking_app/features/doctor/profile/presantation/bloc/profile_bloc.dart';
import 'package:doctor_booking_app/core/splash/presentation/bloc/splash_bloc.dart';
import 'package:doctor_booking_app/features/doctor/shedule/data/datasources/schedule_remote_data_source.dart';
import 'package:doctor_booking_app/features/doctor/shedule/data/repositories/schedule_repository_impl.dart';
import 'package:doctor_booking_app/features/doctor/shedule/domain/repositories/schedule_repository.dart';
import 'package:doctor_booking_app/features/doctor/shedule/domain/usecases/save_schedule_usecase.dart';
import 'package:doctor_booking_app/features/doctor/shedule/presantation/bloc/schedule_bloc.dart';
import 'package:doctor_booking_app/features/user/appointment/data/datasources/user_appointment_remote_data_source.dart';
import 'package:doctor_booking_app/features/user/appointment/data/repositories/user_appointment_repository_impl.dart';
import 'package:doctor_booking_app/features/user/appointment/domain/repositories/user_appointment_repository.dart';
import 'package:doctor_booking_app/features/user/appointment/domain/usecases/book_appointment_usecase.dart';
import 'package:doctor_booking_app/features/user/appointment/domain/usecases/get_doctor_availability_usecase.dart';
import 'package:doctor_booking_app/features/user/appointment/presantation/bloc/booking_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> setupInjection() async {
  // Core
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  sl.registerLazySingleton<AppointmentsRealtimeService>(
    () => AppointmentsRealtimeService(supabaseClient: sl()),
  );

  await _initUser();
  await _initDoctor();
  await _initDoctorCrud();
  await _initDoctorSchedule();
  await _initUserHome();
  await _initUserBooking();
  _initDoctorAppointments();
}

void _initDoctorAppointments() {
  // Data sources
  sl.registerLazySingleton<DoctorAppointmentRemoteDataSource>(
    () => DoctorAppointmentRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // Repositories
  sl.registerLazySingleton<DoctorAppointmentRepository>(
    () => DoctorAppointmentRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetDoctorAppointmentsUseCase(sl()));
  sl.registerLazySingleton(() => AcceptAppointmentUseCase(sl()));
  sl.registerLazySingleton(() => RejectAppointmentUseCase(sl()));

  // Blocs
  sl.registerFactory(
    () => DoctorAppointmentsBloc(
      getDoctorAppointments: sl(),
      acceptAppointment: sl(),
      rejectAppointment: sl(),
    ),
  );
}

Future<void> _initUserBooking() async {
  // BLoC
  sl.registerFactory(
    () => BookingBloc(getDoctorAvailability: sl(), bookAppointment: sl()),
  );

  // Use cases
  sl.registerLazySingleton(
    () => GetDoctorAvailabilityUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => BookAppointmentUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<UserAppointmentRepository>(
    () => UserAppointmentRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<UserAppointmentRemoteDataSource>(
    () => UserAppointmentRemoteDataSourceImpl(supabaseClient: sl()),
  );
}

Future<void> _initDoctorSchedule() async {
  sl.registerLazySingleton<ScheduleRemoteDataSource>(
    () =>
        ScheduleRemoteDataSourceImpl(supabaseClient: Supabase.instance.client),
  );

  sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => SaveScheduleUseCase(repository: sl()));

  sl.registerFactory(() => ScheduleBloc(saveScheduleUseCase: sl()));
}

Future<void> _initUser() async {
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => IsLoggedIn(sl()));
  sl.registerLazySingleton(() => Signout(sl()));

  sl.registerFactory(() => AuthBloc(sl(), sl(), sl()));
  sl.registerFactory(() => SplashBloc(sl()));
  sl.registerFactory(() => ChatBloc(getUserDoctors: sl()));
}

Future<void> _initDoctor() async {
  // Data Source
  sl.registerLazySingleton<DoctorAuthRemoteDataSource>(
    () => DoctorAuthRemoteDataSource(),
  );

  // Repository
  sl.registerLazySingleton<DoctorAuthRepository>(
    () => DoctorAuthRepositoryImpl(sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => DoctorLogin(sl()));
  sl.registerLazySingleton(() => DoctorSignUp(sl()));
  sl.registerLazySingleton(() => GetAuthDoctor(sl()));
  sl.registerLazySingleton(() => DoctorSignOut(sl()));
  sl.registerLazySingleton(() => DoctorIsLoggedIn(sl()));

  // Bloc
  sl.registerFactory(
    () => DoctorAuthBloc(
      sl<DoctorLogin>(),
      sl<DoctorSignUp>(),
      sl<GetAuthDoctor>(),
      sl<DoctorSignOut>(),
    ),
  );

  sl.registerFactory(() => DoctorSplashBloc(sl<DoctorIsLoggedIn>()));
}

Future<void> _initDoctorCrud() async {
  sl.registerLazySingleton<DoctorRemoteDataSource>(
    () => DoctorRemoteDataSource(),
  );

  sl.registerLazySingleton<DoctorRepository>(() => DoctorRepositoryImpl(sl()));

  sl.registerLazySingleton(() => AddDoctor(sl()));
  sl.registerLazySingleton(() => UpdateDoctor(sl()));
  sl.registerLazySingleton(() => UploadImage(sl()));
  sl.registerLazySingleton(() => GetDoctor(sl()));
  sl.registerLazySingleton(() => DeleteDoctor(sl()));
  sl.registerLazySingleton(() => GetDoctorProfile(sl()));

  sl.registerFactory(
    () => DoctorBloc(
      addDoctor: sl(),
      getDoctors: sl(),
      updateDoctor: sl(),
      deleteDoctor: sl(),
      uploadImage: sl(),
    ),
  );

  sl.registerFactory(() => ProfileBloc(getDoctorProfile: sl()));
}

Future<void> _initUserHome() async {
  sl.registerLazySingleton(() => UserHomeRemoteDataSource());
  sl.registerLazySingleton<UserHomeRepository>(
    () => UserHomeRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetUserDoctors(sl()));

  sl.registerFactory(() => UserHomeBloc(getUserDoctors: sl()));
}

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
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupInjection() async {
  await _initUser();
  await _initDoctor();
  await _initDoctorCrud();
  await _initUserHome();
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

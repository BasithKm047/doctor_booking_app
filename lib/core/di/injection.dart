import 'package:doctor_booking_app/features/doctor/auth/data/data_source/doctor_auth_remote_data_source.dart';
import 'package:doctor_booking_app/features/doctor/auth/data/repositories/doctor_auth_repository_impl.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/repositories/doctor_auth_repository.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/usecases/doctor_is_loggedin.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/usecases/doctor_signout.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/usecases/get_current_doctor.dart';
import 'package:doctor_booking_app/features/doctor/auth/domain/usecases/send_magic_link.dart';
import 'package:doctor_booking_app/features/doctor/auth/presentation/bloc/docto_auth_bloc.dart';
import 'package:doctor_booking_app/features/doctor/doctor_splash/presantation/bloc/doctor_splash_bloc.dart';
import 'package:doctor_booking_app/features/user/auth/data/data_source/auth_remote_data_source.dart';
import 'package:doctor_booking_app/features/user/auth/data/repositories/auth_repository_impl.dart';
import 'package:doctor_booking_app/features/user/auth/domain/repositories/auth_repositories.dart';
import 'package:doctor_booking_app/features/user/auth/domain/usecase/is_logged_in.dart';
import 'package:doctor_booking_app/features/user/auth/domain/usecase/sendotp.dart';
import 'package:doctor_booking_app/features/user/auth/domain/usecase/signout.dart';
import 'package:doctor_booking_app/features/user/auth/domain/usecase/verifyotp.dart';
import 'package:doctor_booking_app/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:doctor_booking_app/features/user/splash/presentation/bloc/splash_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupInjection() async {
  await _initUser();
  await _initDoctor();
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
  sl.registerLazySingleton(() => SendMagicLink(sl()));
  sl.registerLazySingleton(() => GetCurrentDoctor(sl()));
  sl.registerLazySingleton(() => DoctorSignOut(sl()));
  sl.registerLazySingleton(() => DoctorIsLoggedIn(sl()));

  // Bloc
  sl.registerFactory(
    () => DoctorAuthBloc(
      sl<SendMagicLink>(),
      sl<GetCurrentDoctor>(),
      sl<DoctorSignOut>(),
    ),
  );

  sl.registerFactory(
    () => DoctorSplashBloc(
      sl<DoctorIsLoggedIn>(),
    ),
  );
}
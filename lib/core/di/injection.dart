import 'package:doctor_booking_app/features/user/auth/data/data_source/auth_remote_data_source.dart';
import 'package:doctor_booking_app/features/user/auth/data/repositories/auth_repository_impl.dart';
import 'package:doctor_booking_app/features/user/auth/domain/repositories/auth_repositories.dart';
import 'package:doctor_booking_app/features/user/auth/domain/usecase/is_logged_in.dart';
import 'package:doctor_booking_app/features/user/auth/domain/usecase/sendotp.dart';
import 'package:doctor_booking_app/features/user/auth/domain/usecase/verifyotp.dart';
import 'package:doctor_booking_app/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:doctor_booking_app/features/user/splash/presentation/bloc/splash_bloc.dart';
import 'package:get_it/get_it.dart';

final getit=GetIt.instance;

Future<void>setupInjection()async{

  // Data sources
  getit.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());
  // Repositories
  getit.registerLazySingleton<AuthRepository>(()=>AuthRepositoryImpl(getit()));

  // Use cases
  getit.registerLazySingleton<SendOtp>(()=>SendOtp(getit()));
  getit.registerLazySingleton<VerifyOtp>(()=>VerifyOtp(getit()));
  getit.registerLazySingleton<IsLoggedIn>(()=>IsLoggedIn(getit()));

  getit.registerFactory(() => AuthBloc(getit(), getit()));
  getit.registerFactory(() => SplashBloc(getit()));

}
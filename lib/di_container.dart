import 'package:dio/dio.dart';
import 'package:restaurant_rider/data/repository/auth_repo.dart';
import 'package:restaurant_rider/data/repository/language_repo.dart';
import 'package:restaurant_rider/data/repository/order_repo.dart';
import 'package:restaurant_rider/data/repository/profile_repo.dart';
import 'package:restaurant_rider/data/repository/splash_repo.dart';
import 'package:restaurant_rider/provider/auth_provider.dart';
import 'package:restaurant_rider/provider/localization_provider.dart';
import 'package:restaurant_rider/provider/language_provider.dart';
import 'package:restaurant_rider/provider/location_provider.dart';
import 'package:restaurant_rider/provider/order_provider.dart';
import 'package:restaurant_rider/provider/profile_provider.dart';
import 'package:restaurant_rider/provider/splash_provider.dart';
import 'package:restaurant_rider/provider/theme_provider.dart';
import 'package:restaurant_rider/provider/tracker_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient('', sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => LanguageRepo());
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => OrderRepo(dioClient: sl(), sharedPreferences: sl()));

  // Provider
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl()));
  sl.registerFactory(() => LanguageProvider(languageRepo: sl()));
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => ProfileProvider(profileRepo: sl()));
  sl.registerFactory(() => OrderProvider(orderRepo: sl()));
  sl.registerFactory(() => LocationProvider(sharedPreferences: sl()));
  sl.registerFactory(() => TrackerProvider());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}

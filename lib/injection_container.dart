
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'config/config.dart';
import 'core/app_export.dart';
import 'core/utils/bloc_observer.dart';
import 'core/utils/cache_helper.dart';

final sl = GetIt.instance;


// define main variables

String appName = '';

String packageName = '';

String version = '';

String buildNumber = '';

var languageCode;

var token;

var refresh_token;

var locale;

var isOnboarding = "No data found!";

Future<void> initializeDependencies() async {
  // Bloc Observer

  Bloc.observer = MyBlocObserver();

  // Shared Preferences

  // await CacheHelper.init();

  // Secure Storage

  SecureStorage.initStorage();

  // Variables getting

  // App Info

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  appName = packageInfo.appName;
  packageName = packageInfo.packageName;
  version = packageInfo.version;
  buildNumber = packageInfo.buildNumber;

  // Dio
  Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'language': languageCode,
      },
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  // Access and Refresh Token
  // dio.interceptors.add(AuthInterceptor(dio));

  // init dio
  sl.registerSingleton<Dio>(dio);

  // Dependencies (Services)

  // Repositories

  // UseCases

  // Network

  // Bloc

}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

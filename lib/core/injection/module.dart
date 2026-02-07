import "package:dio/dio.dart";
import "package:injectable/injectable.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:talker/talker.dart";

import "package:wink_dupe/core/routing/router.dart";

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio(
      BaseOptions(
        // baseUrl will be configured via environment
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    // Add interceptors
    dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      // AuthInterceptor(), // To be implemented later
      // ErrorInterceptor(), // To be implemented later
    ]);

    return dio;
  }

  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @lazySingleton
  AppRouter get router => AppRouter();

  @lazySingleton
  Talker get logger => Talker();
}

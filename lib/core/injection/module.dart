import "package:dio/dio.dart";
import "package:injectable/injectable.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:talker/talker.dart";

import "package:wink_dupe/config/environment.dart";
import "package:wink_dupe/core/routing/router.dart";

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppEnvironment.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
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

  @lazySingleton
  SupabaseClient get supabase => Supabase.instance.client;
}

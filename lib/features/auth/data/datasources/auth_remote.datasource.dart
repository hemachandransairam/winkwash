import "package:dio/dio.dart";
import "package:injectable/injectable.dart";

import "package:wink_dupe/core/error/exceptions.dart";
import "package:wink_dupe/features/auth/data/models/request/login_request.model.dart";
import "package:wink_dupe/features/auth/data/models/response/login_response.model.dart";

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<void> logout();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post("/auth/login", data: request.toJson());

      return LoginResponse.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException.fromDioException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post("/auth/logout");
    } on DioException catch (e) {
      throw ServerException.fromDioException(e);
    }
  }
}

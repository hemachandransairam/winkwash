import "package:injectable/injectable.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:wink_dupe/core/error/exceptions.dart";
import "package:wink_dupe/features/auth/data/models/request/login_request.model.dart";
import "package:wink_dupe/features/auth/data/models/response/login_response.model.dart";

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<void> logout();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: request.email,
        password: request.password,
      );

      final user = response.user;
      if (user == null)
        throw const ServerException("Login failed: No user returned");

      return LoginResponse(
        user: UserDto(
          id: user.id,
          email: user.email ?? "",
          name: user.userMetadata?["full_name"] ?? "User",
        ),
        token: response.session?.accessToken ?? "",
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

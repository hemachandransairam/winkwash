import "package:fpdart/fpdart.dart";
import "package:injectable/injectable.dart";

import "package:wink_dupe/core/error/exceptions.dart";
import "package:wink_dupe/core/error/failures.dart";
import "package:wink_dupe/features/auth/data/datasources/auth_remote.datasource.dart";
import "package:wink_dupe/features/auth/data/models/request/login_request.model.dart";
import "package:wink_dupe/features/auth/domain/entities/user.entity.dart";
import "package:wink_dupe/features/auth/domain/repositories/auth.repository.dart";

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _remoteDataSource.login(request);

      // Map DTO to entity
      final user = User(
        id: response.user.id,
        email: response.user.email,
        name: response.user.name,
      );

      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure("An unexpected error occurred: $e"));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure("An unexpected error occurred: $e"));
    }
  }
}

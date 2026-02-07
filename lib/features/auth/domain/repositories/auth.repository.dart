import "package:fpdart/fpdart.dart";

import "package:wink_dupe/core/error/failures.dart";
import "package:wink_dupe/features/auth/domain/entities/user.entity.dart";

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> logout();
}

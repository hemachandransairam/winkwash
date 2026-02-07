import "package:fpdart/fpdart.dart";
import "package:injectable/injectable.dart";

import "package:wink_dupe/core/error/failures.dart";
import "package:wink_dupe/features/auth/domain/entities/user.entity.dart";
import "package:wink_dupe/features/auth/domain/repositories/auth.repository.dart";

@injectable
class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, User>> execute({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}

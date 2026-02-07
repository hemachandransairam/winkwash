import "package:wink_dupe/core/utils/compositions.dart";
import "package:injectable/injectable.dart";

import "package:wink_dupe/core/error/failures.dart";
import "package:wink_dupe/features/auth/domain/entities/user.entity.dart";
import "package:wink_dupe/features/auth/domain/usecases/login.usecase.dart";

@injectable
class LoginState {
  LoginState(this._loginUseCase);

  final LoginUseCase _loginUseCase;

  // Reactive state
  final isLoading = ref(false);
  final user = ref<User?>(null);
  final error = ref<Failure?>(null);

  // Actions
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    error.value = null;

    final result = await _loginUseCase.execute(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => error.value = failure,
      (success) => user.value = success,
    );

    isLoading.value = false;
  }

  void clearError() {
    error.value = null;
  }
}

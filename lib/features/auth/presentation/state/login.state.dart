import "package:injectable/injectable.dart";
import "package:wink_dupe/core/error/failures.dart";
import "package:wink_dupe/core/utils/compositions.dart";
import "package:wink_dupe/features/auth/domain/entities/user.entity.dart";
import "package:wink_dupe/features/auth/domain/usecases/login.usecase.dart";

@lazySingleton
class LoginState {
  LoginState(this._loginUseCase);

  final LoginUseCase _loginUseCase;

  // Reactive state
  final isLoading = ref(false);
  final user = ref<User?>(null);
  final error = ref<Failure?>(null);

  final email = ref("");
  final password = ref("");
  final obscurePassword = ref(true);

  late final isFormValid = computed(
    () => email.value.isNotEmpty && password.value.isNotEmpty,
  );

  // Actions
  Future<void> login(String emailInput, String passwordInput) async {
    isLoading.value = true;
    error.value = null;

    final result = await _loginUseCase.execute(
      email: emailInput,
      password: passwordInput,
    );

    result.fold(
      (failure) => error.value = failure,
      (success) => user.value = success,
    );

    isLoading.value = false;
  }

  void toggleObscurePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  void clearError() {
    error.value = null;
  }
}

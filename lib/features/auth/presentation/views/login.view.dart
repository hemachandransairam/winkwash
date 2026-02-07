import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:mix/mix.dart";

import "package:wink_dupe/core/error/error_handler.dart";
import "package:wink_dupe/core/injection/injection.dart";
import "package:wink_dupe/core/utils/compositions.dart";
import "package:wink_dupe/features/auth/presentation/state/login.state.dart";
import "package:wink_dupe/features/auth/presentation/styles/auth.style.dart";

@RoutePage()
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = useComposable(() => getIt<LoginState>());

    // Controllers
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Observer(
        builder: (context) {
          // Observe error and show snackbar
          if (state.error.value != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showErrorSnackbar(
                context,
                title: "Login Error",
                message: state.error.value!.message,
              );
              state.clearError();
            });
          }

          if (state.user.value != null) {
            // Handle success (e.g., navigate)
          }

          return Center(
            child: VBox(
              style: AuthStyle.container,
              children: [
                StyledText("Login", style: AuthStyle.title),
                Box(
                  style: AuthStyle.inputField,
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Box(
                  style: AuthStyle.inputField,
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (state.isLoading.value)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed:
                        () => state.login(
                          emailController.text,
                          passwordController.text,
                        ),
                    child: const Text("Sign In"),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

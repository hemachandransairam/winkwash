import "package:flutter/material.dart";
import "package:wink_dupe/core/error/error_handler.dart";
import "package:wink_dupe/core/injection/injection.dart";
import "package:wink_dupe/core/utils/compositions.dart";
import "package:wink_dupe/features/auth/presentation/state/login.state.dart";

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final LoginState state;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    state = getIt<LoginState>();
    _emailController.addListener(
      () => state.email.value = _emailController.text,
    );
    _passwordController.addListener(
      () => state.password.value = _passwordController.text,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Observer(
          builder: (context) {
            // Navigation Handling on Success
            if (state.user.value != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // For now, in "Old UI" style, we'll use traditional navigation or a simple home route
                // Until we restore the full router
                debugPrint("Login Successful! Navigating...");
              });
            }

            // Error Handling
            if (state.error.value != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showErrorSnackbar(
                  context,
                  title: "Signature Error",
                  message: state.error.value!.message,
                );
                state.clearError();
              });
            }

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: isSmallScreen ? 15 : 30),
                      const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Hi, Welcome Back! You've been missed!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      SizedBox(height: isSmallScreen ? 15 : 25),

                      _buildInputLabel("Email"),
                      _buildTextField(
                        controller: _emailController,
                        hintText: "example@gmail.com",
                      ),

                      const SizedBox(height: 12),

                      _buildInputLabel("Password"),
                      _buildTextField(
                        controller: _passwordController,
                        hintText: "****************",
                        isPassword: true,
                        obscureText: state.obscurePassword.value,
                        onToggle: state.toggleObscurePassword,
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            "Forgot Password",
                            style: TextStyle(
                              color: Color(0xFF1D3557),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 15 : 25),

                      // Main Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed:
                              (state.isFormValid.value &&
                                      !state.isLoading.value)
                                  ? () => state.login(
                                    _emailController.text,
                                    _passwordController.text,
                                  )
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF000B1E),
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child:
                              state.isLoading.value
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color:
                                          state.isFormValid.value
                                              ? Colors.white
                                              : Colors.grey.shade600,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 15 : 25),
                      const Text(
                        "Or sign in with",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialCircle("assets/google.png", () {}),
                          const SizedBox(width: 20),
                          _socialCircle("assets/fb.png", () {}),
                          const SizedBox(width: 20),
                          _socialCircle("assets/x.png", () {}),
                        ],
                      ),

                      const Spacer(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D3557),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 4),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.4), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF000814)),
        ),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 18,
                  ),
                  onPressed: onToggle,
                )
                : null,
      ),
    );
  }

  Widget _socialCircle(String assetPath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 50,
        height: 50,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Image.asset(assetPath, fit: BoxFit.contain),
      ),
    );
  }
}

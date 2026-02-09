import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/login.dart';
import 'screens/onboarding_page.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: "https://qxxsclrmpscofinjedjz.supabase.co",
      anonKey: "sb_publishable_bWTgLtV7gE2xJ5qZsM--FA_QPxL20_Y",
    );
  } catch (e) {
    debugPrint("Supabase initialization error: $e");
  }

  final prefs = await SharedPreferences.getInstance();
  final bool showOnboarding = !(prefs.getBool('onboarding_shown') ?? false);
  final bool isLoggedIn = Supabase.instance.client.auth.currentSession != null;

  runApp(MyApp(showOnboarding: showOnboarding, isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;
  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.showOnboarding,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wink Wash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF01102B),
          primary: const Color(0xFF01102B),
          secondary: Colors.blueAccent,
          surface: Colors.white,
          background: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF01102B),
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF01102B),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF01102B), width: 1.5),
          ),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
      ),
      home:
          isLoggedIn
              ? const HomeScreen()
              : (showOnboarding ? const OnboardingPage() : const LoginPage()),
    );
  }
}

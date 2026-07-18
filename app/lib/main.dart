import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/authention/screens/sign_in_screen.dart';
import 'features/authention/services/auth_service.dart';
import 'features/Home/screen/home_shell_screen.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'theme/neumorphic_theme.dart';
import 'features/Home/services/tournament_service.dart';
import 'features/Home/services/media_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Start pre-fetching data in background on app startup
  TournamentService.instance.fetchFeaturedEvents();
  MediaService.instance.fetchMediaItems();

  runApp(const GenzApp());
}

class GenzApp extends StatefulWidget {
  const GenzApp({super.key});

  @override
  State<GenzApp> createState() => _GenzAppState();
}

class _GenzAppState extends State<GenzApp> {
  late final Future<Widget> _startScreen = _resolveStartScreen();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _startScreen,
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GenZ eSports',
          theme: NeumorphicTheme.lightTheme(),
          home: snapshot.data ?? const _SplashScreen(),
        );
      },
    );
  }

  Future<Widget> _resolveStartScreen() async {
    try {
      await AuthService.instance.restoreSession();
    } catch (error) {
      debugPrint('Unable to restore session: $error');
    }

    if (AuthService.instance.isLoggedIn) {
      return const HomeShellScreen();
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding =
          prefs.getBool(OnboardingScreen.seenKey) ?? false;

      return hasSeenOnboarding
          ? const SignInScreen()
          : const OnboardingScreen();
    } catch (error) {
      debugPrint('Unable to load onboarding state: $error');
      return const OnboardingScreen();
    }
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

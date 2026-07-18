import 'package:flutter/material.dart';

import '../../../theme/neumorphic_theme.dart';
import '../../../utiles/widgets/auth/auth_screen_layout.dart';
import '../../../utiles/widgets/glass/glass_kit.dart';
import '../../Home/screen/home_shell_screen.dart';
import '../services/auth_service.dart';
import 'forgot_password_screen.dart';
import 'sign_up_screen.dart';

/// Screen for users to sign in to their GenZ eSports account.
/// Implements premium glassmorphism styling and utilizes global shared widgets.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Text controllers to hold user credentials input
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;          // Tracks API login call status
  bool _obscurePassword = true;     // Controls visibility of password characters
  String? _errorMessage;            // Stores error message if login fails

  @override
  void dispose() {
    // Dispose controllers to free up memory resources when screen is removed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Builds the full login screen UI with the shared auth layout and glass widgets.
  @override
  Widget build(BuildContext context) {
    return AuthScreenLayout(
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      hero: Column(
        children: [
          const GlassLogoMark(),
          const SizedBox(height: 12),
          Text(
            'GenZ eSports',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Welcome back, champion',
            style: TextStyle(
              color: kTextMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
      content: GlassCard(
        padding: const EdgeInsets.all(26),
        borderRadius: 28,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sign In',
              style: TextStyle(
                color: kTextHeading,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Enter your credentials to continue',
              style: TextStyle(
                color: kTextMuted,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 28),
            GlassTextField(
              controller: _emailController,
              label: 'Email',
              hintText: 'name@example.com',
              keyboardType: TextInputType.emailAddress,
              prefix: const Icon(
                Icons.mail_outline_rounded,
                size: 20,
                color: kTextSubtle,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kTextMuted,
                    letterSpacing: 0.3,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: kPrimaryBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            GlassTextField(
              controller: _passwordController,
              hintText: '••••••••',
              obscureText: _obscurePassword,
              prefix: const Icon(
                Icons.lock_outline_rounded,
                size: 20,
                color: kTextSubtle,
              ),
              suffix: IconButton(
                onPressed: () => setState(
                  () => _obscurePassword = !_obscurePassword,
                ),
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: kTextSubtle,
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_errorMessage != null) ...[
              GlassErrorBox(message: _errorMessage!),
              const SizedBox(height: 18),
            ],
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomContent: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account?",
            style: TextStyle(
              color: kTextMuted,
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SignUpScreen()),
              );
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(
                color: kPrimaryBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Sends the entered credentials to the auth service and navigates on success.
  Future<void> _handleLogin() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    final navigator = Navigator.of(context);
    try {
      await AuthService.instance.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      // Navigate to main Home shell screen on success
      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeShellScreen()),
      );
    } on AuthException catch (error) {
      setState(() => _errorMessage = error.message);
    } catch (_) {
      setState(() => _errorMessage =
          'Unable to login. Please check your credentials and try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../theme/neumorphic_theme.dart';
import '../../../utiles/widgets/auth/auth_screen_layout.dart';
import '../../../utiles/widgets/glass/glass_kit.dart';
import '../services/auth_service.dart';
import 'verify_email_screen.dart';

/// Screen for users to create a new GenZ eSports account.
/// Integrates custom glassmorphic panels and input fields from the global library.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Input text controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedGame = 'fc26';    // Default selected favorite game
  bool _isLoading = false;          // Tracks signup status
  bool _obscurePassword = true;     // Controls password display visibility
  String? _errorMessage;            // Stores error feedback if API call fails

  @override
  void dispose() {
    // Memory cleanup: dispose controllers when this view is popped
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenLayout(
      appBar: GlassAppBar(onBack: () => Navigator.of(context).pop()),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      hero: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Join the Arena',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 30),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your professional profile and compete',
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: kTextMuted,
            ),
          ),
        ],
      ),
      content: GlassCard(
        padding: const EdgeInsets.all(24),
        borderRadius: 28,
        child: Column(
          children: [
            GlassTextField(
              controller: _nameController,
              label: 'Full Name',
              hintText: 'Enter your legal name',
              prefix: const Icon(
                Icons.person_outline_rounded,
                size: 20,
                color: kTextSubtle,
              ),
            ),
            const SizedBox(height: 16),
            GlassTextField(
              controller: _emailController,
              label: 'Email',
              hintText: 'name@organization.com',
              keyboardType: TextInputType.emailAddress,
              prefix: const Icon(
                Icons.mail_outline_rounded,
                size: 20,
                color: kTextSubtle,
              ),
            ),
            const SizedBox(height: 16),
            GlassTextField(
              controller: _passwordController,
              label: 'Password',
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
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: kTextSubtle,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kPrimaryBlue.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: kPrimaryBlue.withValues(alpha: 0.15),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: kPrimaryBlue,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'A one-time code will be sent to your email to verify your account.',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: kTextMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GlassTextField(
              controller: _phoneController,
              label: 'Phone Number',
              hintText: '+92 300 1234567',
              keyboardType: TextInputType.phone,
              prefix: const Icon(
                Icons.phone_outlined,
                size: 20,
                color: kTextSubtle,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Favorite Game',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kTextMuted,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedGame,
                      dropdownColor: const Color(0xFF0B2559),
                      style: const TextStyle(
                        color: kTextHeading,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kPrimaryBlue.withValues(alpha: 0.10),
                        prefixIcon: const Icon(
                          Icons.sports_esports_rounded,
                          size: 20,
                          color: kTextSubtle,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: kPrimaryBlue.withValues(alpha: 0.27)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: kPrimaryBlue.withValues(alpha: 0.20)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: kPrimaryBlue,
                            width: 1.5,
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'fc26', child: Text('FC26')),
                        DropdownMenuItem(value: 'tekken 8', child: Text('Tekken 8')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _selectedGame = value);
                      },
                    ),
                  ),
                ),
              ],
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
                onPressed: _isLoading ? null : _handleSignUp,
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
                        'Create Account',
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
      bottomContent: Column(
        children: [
          const SizedBox(height: 28),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  style: TextStyle(
                    color: kTextMuted,
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: kPrimaryBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Center(
            child: Text(
              'By signing up, you agree to GenZ eSports Terms of Service and Privacy Policy.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                height: 1.4,
                color: kTextSubtle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Sends the registration details to AuthService and redirects to verification
  Future<void> _handleSignUp() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    try {
      // Validate empty fields before API call
      if (_nameController.text.trim().isEmpty ||
          _emailController.text.trim().isEmpty ||
          _phoneController.text.trim().isEmpty ||
          _passwordController.text.isEmpty) {
        throw AuthException('Please fill all required fields.');
      }
      final navigator = Navigator.of(context);
      await AuthService.instance.register(
        fullname: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        number: _phoneController.text,
        favGame: _selectedGame,
      );
      if (!mounted) return;
      // Redirect user to the verification code entry screen
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (_) => VerifyEmailScreen(
            email: _emailController.text.trim(),
          ),
        ),
      );
    } on AuthException catch (error) {
      setState(() => _errorMessage = error.message);
    } catch (_) {
      setState(() =>
          _errorMessage = 'Unable to create account. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

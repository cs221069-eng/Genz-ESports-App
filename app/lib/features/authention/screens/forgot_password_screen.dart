import 'package:flutter/material.dart';

import '../../../theme/neumorphic_theme.dart';
import '../../../utiles/widgets/glass/glass_kit.dart';
import '../../authention/services/auth_service.dart';

/// Screen allowing users to reset their forgotten passwords via OTP verification.
/// Stylized using unified premium glassmorphic visual widgets.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Input text controllers
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;            // Tracks network operation status
  bool _otpSent = false;              // Tracks current step (false = enter email, true = verify code & reset)
  bool _showNewPassword = false;      // Controls visibility of new password
  bool _showConfirmPassword = false;  // Controls visibility of confirm password
  String? _debugOtp;                  // Holds OTP in dev/debug mode

  @override
  void dispose() {
    // Release controller resources to avoid leaks
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Step 1: Submits email and requests an OTP code from the backend
  Future<void> _handleSendOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter your email.'),
        backgroundColor: Color(0xFFBA1A1A),
      ));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final debugOtp =
          await AuthService.instance.requestPasswordReset(email: email);
      if (!mounted) return;

      setState(() {
        _otpSent = true;
        _debugOtp = debugOtp;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Reset code sent! Check your email.'),
        backgroundColor: Color(0xFF0E8A52),
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: const Color(0xFFBA1A1A),
      ));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Step 2: Validates OTP and updates the password
  Future<void> _handleResetPassword() async {
    final otp = _otpController.text.trim();
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter the OTP code.'),
        backgroundColor: Color(0xFFBA1A1A),
      ));
      return;
    }

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter and confirm your new password.'),
        backgroundColor: Color(0xFFBA1A1A),
      ));
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password must be at least 6 characters.'),
        backgroundColor: Color(0xFFBA1A1A),
      ));
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Passwords do not match.'),
        backgroundColor: Color(0xFFBA1A1A),
      ));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.instance.resetPassword(
        email: _emailController.text.trim(),
        otp: otp,
        newPassword: newPassword,
      );
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password reset successful! You can now login.'),
        backgroundColor: Color(0xFF0E8A52),
      ));
      Navigator.of(context).pop(); // Exit screen back to sign in
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: const Color(0xFFBA1A1A),
      ));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GlassBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: GlassCard(
                  padding: const EdgeInsets.all(26),
                  borderRadius: 28,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Descriptive prompt text depending on current step
                      Text(
                        _otpSent
                            ? 'Enter the code sent to your email and set a new password.'
                            : 'Enter your email to receive a password reset code.',
                        style: const TextStyle(
                          fontSize: 15,
                          color: kTextHeading,
                          height: 1.45,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Email Input Field (Disabled after code is sent)
                      GlassTextField(
                        controller: _emailController,
                        label: 'Email',
                        hintText: 'name@example.com',
                        keyboardType: TextInputType.emailAddress,
                        readOnly: _otpSent,
                        prefix: const Icon(
                          Icons.mail_outline_rounded,
                          size: 20,
                          color: kTextSubtle,
                        ),
                      ),

                      // CTA for Step 1
                      if (!_otpSent) ...[
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 52,
                          child: FilledButton(
                            onPressed: _isLoading ? null : _handleSendOtp,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Send Reset Code'),
                          ),
                        ),
                      ],

                      // ── Step 2: OTP & Password Input Section ──────────────
                      if (_otpSent) ...[
                        const SizedBox(height: 16),
                        
                        // Verification Code
                        GlassTextField(
                          controller: _otpController,
                          label: 'OTP Code',
                          hintText: 'Enter reset code',
                          keyboardType: TextInputType.number,
                          prefix: const Icon(
                            Icons.pin_outlined,
                            size: 20,
                            color: kTextSubtle,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // New Password Field
                        GlassTextField(
                          controller: _newPasswordController,
                          label: 'New Password',
                          hintText: 'Minimum 6 characters',
                          obscureText: !_showNewPassword,
                          prefix: const Icon(
                            Icons.lock_outline_rounded,
                            size: 20,
                            color: kTextSubtle,
                          ),
                          suffix: IconButton(
                            icon: Icon(_showNewPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                              size: 20,
                              color: kTextSubtle,
                            ),
                            onPressed: () => setState(
                                () => _showNewPassword = !_showNewPassword),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Confirm New Password Field
                        GlassTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm New Password',
                          hintText: 'Retype new password',
                          obscureText: !_showConfirmPassword,
                          prefix: const Icon(
                            Icons.lock_outline_rounded,
                            size: 20,
                            color: kTextSubtle,
                          ),
                          suffix: IconButton(
                            icon: Icon(_showConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                              size: 20,
                              color: kTextSubtle,
                            ),
                            onPressed: () => setState(
                                () => _showConfirmPassword = !_showConfirmPassword),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Reset Action Button
                        SizedBox(
                          height: 52,
                          child: FilledButton(
                            onPressed: _isLoading ? null : _handleResetPassword,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Reset Password'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Change email / Resend code link
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  setState(() {
                                    _otpSent = false;
                                    _otpController.clear();
                                    _newPasswordController.clear();
                                    _confirmPasswordController.clear();
                                    _debugOtp = null;
                                  });
                                },
                          child: const Text('Resend code / Change email'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

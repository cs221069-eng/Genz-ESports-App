import 'package:flutter/material.dart';

import '../../Home/screen/home_shell_screen.dart';
import '../services/auth_service.dart';
import '../../../utiles/widgets/glass/glass_kit.dart';
import '../../../utiles/widgets/neumorphic/neumorphic_button.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, required this.email});

  final String email;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Verify Email'),
      ),
      body: GlassBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: GlassCard(
                  padding: const EdgeInsets.all(26),
                  borderRadius: 28,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Enter the code sent to ${widget.email}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: const Color(0xFFECF7FF),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 24),
                      GlassTextField(
                        controller: _otpController,
                        label: 'Verification code',
                        hintText: '123456',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 18),
                      if (_errorMessage != null) ...[
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 18),
                      ],
                      NeumorphicButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                setState(() {
                                  _errorMessage = null;
                                  _isLoading = true;
                                });

                                try {
                                  final navigator = Navigator.of(context);
                                  await AuthService.instance.verifyEmail(
                                    email: widget.email,
                                    otp: _otpController.text.trim(),
                                  );

                                  if (!navigator.mounted) return;
                                  navigator.pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (_) => const HomeShellScreen(),
                                    ),
                                    (_) => false,
                                  );
                                } on AuthException catch (error) {
                                  setState(() {
                                    _errorMessage = error.message;
                                  });
                                } catch (_) {
                                  setState(() {
                                    _errorMessage =
                                        'Unable to verify email. Please try again.';
                                  });
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              },
                        child: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Verify Email'),
                      ),
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

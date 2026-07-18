import 'package:flutter/material.dart';
import '../../../theme/neumorphic_theme.dart';
import '../../../utiles/widgets/neumorphic/neumorphic_container.dart';
import '../../../utiles/widgets/glass/glass_kit.dart';
import '../../authention/services/auth_service.dart';

const profilePrimaryColor = kPrimaryBlue;
const profileBackgroundColor = kBackground;
const profileCardColor = kSurfaceDark;
const profileOutlineColor = Color(0xFF132C61);
const profileMutedTextColor = kTextMuted;
const profileHeadingColor = kTextHeading;
const profileSoftColor = Color(0xFF132C61);

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  String _displayName = AuthService.instance.currentUser?.fullname ?? 'Unknown';

  /// Shows the dialog to update the user's display name.
  void _showDisplayNameDialog() {
    final controller = TextEditingController(text: _displayName);
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF0B2559),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFF132C61)),
              ),
              title: const Text(
                'Update Display Name',
                style: TextStyle(
                  color: profileHeadingColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter your new display name below.',
                    style: TextStyle(
                      color: profileMutedTextColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Replaced custom TextField with GlassTextField
                  GlassTextField(
                    controller: controller,
                    readOnly: isLoading,
                    hintText: 'Display name',
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: profileMutedTextColor),
                  ),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final newName = controller.text.trim();
                          if (newName.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Display name cannot be empty'),
                                backgroundColor: Color(0xFFBA1A1A),
                              ),
                            );
                            return;
                          }

                          setDialogState(() => isLoading = true);

                          try {
                            await AuthService.instance
                                .updateDisplayName(newName);
                            if (!mounted) return;

                            setState(() {
                              _displayName = AuthService
                                      .instance.currentUser?.fullname ??
                                  newName;
                            });

                            Navigator.of(dialogContext).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Display name updated successfully!'),
                                backgroundColor: Color(0xFF0E8A52),
                              ),
                            );
                          } catch (e) {
                            setDialogState(() => isLoading = false);
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                                backgroundColor: const Color(0xFFBA1A1A),
                              ),
                            );
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: profilePrimaryColor,
                          ),
                        )
                      : const Text(
                          'Save',
                          style: TextStyle(
                            color: profilePrimaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Shows the dialog to update the user's password.
  void _showUpdatePasswordDialog() {
    final currentPasswordCtrl = TextEditingController();
    final newPasswordCtrl = TextEditingController();
    final confirmPasswordCtrl = TextEditingController();
    bool isLoading = false;
    bool showCurrentPassword = false;
    bool showNewPassword = false;
    bool showConfirmPassword = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF0B2559),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFF132C61)),
              ),
              title: const Text(
                'Update Password',
                style: TextStyle(
                  color: profileHeadingColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Enter your current password and choose a new one.',
                      style: TextStyle(
                        color: profileMutedTextColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Replaced custom password fields with global GlassTextField
                    GlassTextField(
                      controller: currentPasswordCtrl,
                      hintText: 'Current password',
                      obscureText: !showCurrentPassword,
                      readOnly: isLoading,
                      suffix: IconButton(
                        icon: Icon(
                          !showCurrentPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: profileMutedTextColor,
                          size: 20,
                        ),
                        onPressed: () {
                          setDialogState(() =>
                              showCurrentPassword = !showCurrentPassword);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    GlassTextField(
                      controller: newPasswordCtrl,
                      hintText: 'New password (min 6 chars)',
                      obscureText: !showNewPassword,
                      readOnly: isLoading,
                      suffix: IconButton(
                        icon: Icon(
                          !showNewPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: profileMutedTextColor,
                          size: 20,
                        ),
                        onPressed: () {
                          setDialogState(
                              () => showNewPassword = !showNewPassword);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    GlassTextField(
                      controller: confirmPasswordCtrl,
                      hintText: 'Confirm new password',
                      obscureText: !showConfirmPassword,
                      readOnly: isLoading,
                      suffix: IconButton(
                        icon: Icon(
                          !showConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: profileMutedTextColor,
                          size: 20,
                        ),
                        onPressed: () {
                          setDialogState(() =>
                              showConfirmPassword = !showConfirmPassword);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: profileMutedTextColor),
                  ),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final current = currentPasswordCtrl.text;
                          final newPass = newPasswordCtrl.text;
                          final confirm = confirmPasswordCtrl.text;

                          if (current.isEmpty ||
                              newPass.isEmpty ||
                              confirm.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('All fields are required'),
                                backgroundColor: Color(0xFFBA1A1A),
                              ),
                            );
                            return;
                          }

                          if (newPass.length < 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'New password must be at least 6 characters'),
                                backgroundColor: Color(0xFFBA1A1A),
                              ),
                            );
                            return;
                          }

                          if (newPass != confirm) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('New passwords do not match'),
                                backgroundColor: Color(0xFFBA1A1A),
                              ),
                            );
                            return;
                          }

                          setDialogState(() => isLoading = true);

                          try {
                            await AuthService.instance.updatePassword(
                              currentPassword: current,
                              newPassword: newPass,
                            );
                            if (!mounted) return;

                            Navigator.of(dialogContext).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Password updated successfully!'),
                                backgroundColor: Color(0xFF0E8A52),
                              ),
                            );
                          } catch (e) {
                            setDialogState(() => isLoading = false);
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                                backgroundColor: const Color(0xFFBA1A1A),
                              ),
                            );
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: profilePrimaryColor,
                          ),
                        )
                      : const Text(
                          'Update',
                          style: TextStyle(
                            color: profilePrimaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = AuthService.instance.currentUser?.email ?? 'No email';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: const Row(
          children: [
            Icon(Icons.sports_esports_rounded, color: profilePrimaryColor),
            SizedBox(width: 8),
            Text(
              'PRO-SERIES',
              style: TextStyle(
                color: profilePrimaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      body: GlassBackground(
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              const Text(
                'Account Settings',
                style: TextStyle(
                  color: profileHeadingColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Update your display name and password.',
                style: TextStyle(
                  color: profileMutedTextColor,
                  fontSize: 15,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),

              // Summary card
              NeumorphicContainer(
                padding: const EdgeInsets.all(18),
                borderRadius: 20,
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0x2617B7FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0x3317B7FF)),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: profilePrimaryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _displayName,
                            style: const TextStyle(
                              color: profileHeadingColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userEmail,
                            style: const TextStyle(
                              color: profileMutedTextColor,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Settings options
              NeumorphicContainer(
                borderRadius: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display Name
                    InkWell(
                      onTap: _showDisplayNameDialog,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color(0x1F17B7FF),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0x3317B7FF)),
                              ),
                              child: const Icon(Icons.person_outline_rounded,
                                  color: profilePrimaryColor, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Display Name',
                                    style: TextStyle(
                                      color: profileHeadingColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _displayName,
                                    style: const TextStyle(
                                      color: profileMutedTextColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded,
                                color: profileMutedTextColor),
                          ],
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Divider(height: 1, color: profileOutlineColor),
                    ),

                    // Update Password
                    InkWell(
                      onTap: _showUpdatePasswordDialog,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color(0x1F17B7FF),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0x3317B7FF)),
                              ),
                              child: const Icon(Icons.lock_outline_rounded,
                                  color: profilePrimaryColor, size: 20),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Update Password',
                                    style: TextStyle(
                                      color: profileHeadingColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Change your account password',
                                    style: TextStyle(
                                      color: profileMutedTextColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded,
                                color: profileMutedTextColor),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

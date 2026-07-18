import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/neumorphic_theme.dart';
import '../../../utiles/widgets/glass/glass_kit.dart';
import '../../../utiles/widgets/neumorphic/neumorphic_container.dart';
import '../../authention/models/auth_user.dart';
import '../../authention/screens/sign_in_screen.dart';
import '../../authention/services/auth_service.dart';
import 'profile_detail_screens.dart';

/// Screen representing the user's profile information and configurations.
/// Contains link to bracket viewer and system settings.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('ProfileScreen build');
    final currentUser = AuthService.instance.currentUser;
    final appBarTitle =
        currentUser != null && currentUser.fullname.trim().isNotEmpty
            ? currentUser.fullname.trim()
            : 'Profile';

    return GlassBackground(
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    titleSpacing: 16,
                    title: Text(
                      appBarTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Profile summary block with visual details
                        _ProfileHeroCard(
                          user: AuthService.instance.currentUser,
                          onViewBracket: () async {
                            final user = AuthService.instance.currentUser;
                            if (user == null || user.token == null || user.token!.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please login to view brackets.'),
                                ),
                              );
                              return;
                            }
                            final String baseFrontendUrl = await AuthService.instance.fetchFrontendUrl();
                            final String urlString = '$baseFrontendUrl/brackets?token=${Uri.encodeComponent(user.token!)}&game=${Uri.encodeComponent(user.favGame ?? 'tekken 8')}';
                            final Uri url = Uri.parse(urlString);
                            try {
                              bool launched = await launchUrl(url, mode: LaunchMode.externalApplication);
                              if (!context.mounted) return;
                              if (!launched) {
                                // Fallback to platform default launch mode
                                launched = await launchUrl(url);
                                if (!context.mounted) return;
                              }
                              if (!launched) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Could not open browser: $urlString'),
                                  ),
                                );
                              }
                            } catch (e) {
                              try {
                                final bool launched = await launchUrl(url);
                                if (!context.mounted) return;
                                if (!launched) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Could not open browser: $urlString'),
                                    ),
                                  );
                                }
                              } catch (e2) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error launching browser: $e2'),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 18),
                        const _ProfileSectionTitle(
                          title: 'Profile Hub',
                          subtitle:
                              'Manage your account settings and security.',
                        ),
                        const SizedBox(height: 12),
                        
                        // Menu choices card
                        _ProfileMenuCard(
                          children: [
                            _ProfileMenuTile(
                              icon: Icons.settings_outlined,
                              label: 'Account Settings',
                              caption:
                                  'Update your display name and password.',
                              onTap: () =>
                                  _openScreen(context, const AccountSettingsScreen()),
                            ),
                            _ProfileMenuTile(
                              icon: Icons.logout_rounded,
                              label: 'Logout',
                              caption: 'Return to the sign-in flow.',
                              iconColor: const Color(0xFFBA1A1A),
                              textColor: const Color(0xFFBA1A1A),
                              showDivider: false,
                              onTap: () async {
                                await AuthService.instance.logout();
                                if (!context.mounted) return;
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const SignInScreen(),
                                  ),
                                  (_) => false,
                                );
                              },
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _openScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

/// Card showing the user's name, email, favorite game, and action items.
class _ProfileHeroCard extends StatelessWidget {
  const _ProfileHeroCard({required this.user, required this.onViewBracket});

  final AuthUser? user;
  final VoidCallback onViewBracket;

  @override
  Widget build(BuildContext context) {
    final profileName =
        (user?.fullname.trim().isNotEmpty ?? false) ? user!.fullname.trim() : 'Unknown Player';
    final profileSubtitle = user != null
        ? '${user!.favGame ?? 'Pro Gamer'} • ${user!.email}'
        : 'Pro Gamer • No email linked';

    return NeumorphicContainer(
      borderRadius: 20,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              // Premium rounded avatar with person icon
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimaryBlue.withValues(alpha: 0.13),
                  border: Border.all(
                    color: kPrimaryBlue.withValues(alpha: 0.5),
                    width: 2.0,
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: kPrimaryBlue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileName,
                      style: const TextStyle(
                        color: kTextHeading,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profileSubtitle,
                      style: const TextStyle(color: kTextMuted, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Helper section header title widget
class _ProfileSectionTitle extends StatelessWidget {
  const _ProfileSectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: kTextHeading,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: kTextMuted, fontSize: 14),
        ),
      ],
    );
  }
}

/// Container card holding settings choices tiles
class _ProfileMenuCard extends StatelessWidget {
  const _ProfileMenuCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      borderRadius: 18,
      padding: EdgeInsets.zero,
      child: Column(children: children),
    );
  }
}

/// Specific settings choice row item tile
class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({
    required this.icon,
    required this.label,
    required this.caption,
    required this.onTap,
    this.iconColor = kPrimaryBlue,
    this.textColor = kTextHeading,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final String caption;
  final VoidCallback onTap;
  final Color iconColor;
  final Color textColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: iconColor.withValues(alpha: 0.25)),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        caption,
                        style: const TextStyle(
                          color: kTextMuted,
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: textColor == const Color(0xFFBA1A1A)
                      ? const Color(0xFFBA1A1A)
                      : kTextMuted,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Divider(height: 1, color: kSurfaceDark),
          ),
      ],
    );
  }
}

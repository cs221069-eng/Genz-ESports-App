import 'package:flutter/material.dart';
import '../../../theme/neumorphic_theme.dart';

import '../../../features/Tournament/model/tournament_entry.dart';
import '../event_participation_sheet.dart';
import '../neumorphic/neumorphic_container.dart';
import '../neumorphic/neumorphic_button.dart';

class TournamentEntryCard extends StatelessWidget {
  const TournamentEntryCard({
    super.key,
    required this.item,
  });

  final TournamentEntry item;

  @override
  Widget build(BuildContext context) {
    final isLive = item.status == TournamentStatus.live;
    final isCompleted = item.status == TournamentStatus.completed;

    return NeumorphicContainer(
      borderRadius: 20,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 196,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(26),
              ),
              gradient: LinearGradient(
                colors: [
                  item.bannerColors[0].withOpacity(0.35),
                  item.bannerColors[1].withOpacity(0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: const Border(
                bottom: BorderSide(color: Color(0x1AFFFFFF), width: 1.0),
              ),
              image: item.imageProvider != null
                  ? DecorationImage(
                      image: item.imageProvider!,
                      fit: BoxFit.cover,
                      colorFilter: const ColorFilter.mode(
                        Color.fromRGBO(0, 0, 0, 0.35),
                        BlendMode.darken,
                      ),
                    )
                  : null,
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -22,
                  top: -20,
                  child: Container(
                    width: 126,
                    height: 126,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: item.badgeColor.withOpacity(0.24),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: item.badgeColor.withOpacity(0.6), width: 1.0),
                    ),
                      child: Text(
                      item.badgeText,
                      style: TextStyle(
                        color: item.badgeColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const Center(
                  child: Icon(
                    Icons.workspace_premium_rounded,
                    size: 56,
                    color: kPrimaryBlue,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: kTextHeading,
                              fontSize: 19,
                              height: 1.25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.game,
                              style: const TextStyle(
                                color: kTextMuted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? const Color(0x1FFFFFFF)
                            : kPrimaryBlue.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCompleted
                              ? const Color(0x33FFFFFF)
                              : kPrimaryBlue.withValues(alpha: 0.20),
                        ),
                      ),
                      child: Text(
                        item.trailingMeta,
                        style: TextStyle(
                          color: isCompleted
                              ? kTextMuted
                              : kPrimaryBlue,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      item.metaIcon,
                      size: 18,
                      color: kTextMuted,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.schedule,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: kTextMuted,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.footerText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isCompleted
                              ? kPrimaryBlue
                              : kTextMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    NeumorphicButton(
                      onPressed: isCompleted
                          ? null
                          : (item.enabled
                              ? () {
                                  showParticipationFormBottomSheet(
                                    context,
                                    eventTitle: item.title,
                                  );
                                }
                              : null),
                      child: Text(item.actionText),
                    ),
                  ],
                ),
                if (isLive) ...[
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  const Text(
                    'Active lobby',
                    style: TextStyle(
                      color: kTextMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kPrimaryBlue.withValues(alpha: 0.20), width: 1.0),
                        ),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: kPrimaryBlue.withValues(alpha: 0.12),
                          child: const Icon(Icons.person, size: 16, color: kPrimaryBlue),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0x33BA1A1A), width: 1.0),
                        ),
                        child: const CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(0x1FBA1A1A),
                          child: Icon(Icons.person, size: 16, color: Color(0xFFBA1A1A)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0x330E8A52), width: 1.0),
                        ),
                        child: const CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(0x1F0E8A52),
                          child: Icon(Icons.person, size: 16, color: Color(0xFF0E8A52)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kPrimaryBlue.withValues(alpha: 0.40), width: 1.0),
                        ),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: kPrimaryBlue,
                          child: const Text(
                            '+12',
                            style: TextStyle(
                              color: kBackground,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

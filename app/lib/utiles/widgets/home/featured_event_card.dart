import 'package:flutter/material.dart';

import '../../../features/Home/model/home_content_models.dart';
import '../event_participation_sheet.dart';
import '../neumorphic/neumorphic_container.dart';
import '../neumorphic/neumorphic_button.dart';

class FeaturedEventCard extends StatelessWidget {
  const FeaturedEventCard({
    super.key,
    required this.event,
  });

  final FeaturedEvent event;

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      borderRadius: 24,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 96,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              gradient: LinearGradient(
                colors: [
                  event.bannerColors[0].withOpacity(0.35),
                  event.bannerColors[1].withOpacity(0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: const Border(
                bottom: BorderSide(color: Color(0x1AFFFFFF), width: 1.0),
              ),
              image: event.imageProvider != null
                  ? DecorationImage(
                      image: event.imageProvider!,
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
                  right: -12,
                  top: -24,
                  child: Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const Center(
                  child: Icon(
                    Icons.emoji_events_rounded,
                    color: Color(0xFF17B7FF),
                    size: 36,
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
                      child: Text(
                        event.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFECF7FF),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x2217B7FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0x3317B7FF)),
                      ),
                      child: Text(
                        event.prize,
                        style: const TextStyle(
                          color: Color(0xFF17B7FF),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  event.schedule,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFA6C9EA),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.attendance,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFA6C9EA),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 110,
                      height: 38,
                      child: NeumorphicButton(
                        onPressed: event.actionEnabled
                            ? () {
                                showParticipationFormBottomSheet(
                                  context,
                                  eventTitle: event.title,
                                );
                              }
                            : null,
                        borderRadius: 12,
                        padding: EdgeInsets.zero,
                        filled: event.actionEnabled,
                        child: Text(
                          event.actionText,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

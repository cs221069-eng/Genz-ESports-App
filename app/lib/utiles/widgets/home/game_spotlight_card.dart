import 'package:flutter/material.dart';

import '../../../features/Home/model/home_content_models.dart';
import '../glass/glass_kit.dart';

class GameSpotlightCard extends StatelessWidget {
  const GameSpotlightCard({
    super.key,
    required this.game,
  });

  final HomeGameSpotlight game;

  @override
  Widget build(BuildContext context) {
    // Choose asset based on game title
    String? assetPath;
    switch (game.title) {
      case 'PUBG':
        assetPath = 'lib/features/Home/assets/pubg.webp';
        break;
      case 'Tekken':
        assetPath = 'lib/features/Home/assets/Tekken 8.webp';
        break;
      case 'FIFA':
        assetPath = 'lib/features/Home/assets/fc26.webp';
        break;
      case 'CS2':
        assetPath = 'lib/features/Home/assets/cs2.webp';
        break;
      default:
        assetPath = null;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        width: 200,
        height: 180, // Fixed height to avoid overflow
        child: GlassCard(
          borderRadius: 22,
          padding: EdgeInsets.zero,
          color: game.colors.first.withOpacity(0.12),
          borderColor: game.colors.first.withOpacity(0.25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top image (full width of card)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                child: assetPath != null
                    ? Image.asset(
                        assetPath,
                        height: 60, // Reduced height
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: game.colors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(
                          game.icon,
                          color: Colors.white,
                          size: 36,
                        ),
                        alignment: Alignment.center,
                      ),
              ),
              // Text content
              Padding(
                padding: const EdgeInsets.all(8), // Reduced padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFECF7FF),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      game.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFA6C5EA),
                        fontSize: 10,
                        height: 1.2,
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

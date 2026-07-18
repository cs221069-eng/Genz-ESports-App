import 'package:flutter/material.dart';

import '../../authention/services/auth_service.dart';
import '../model/home_content_models.dart';
import '../services/media_service.dart';
import '../../../utiles/widgets/glass/glass_kit.dart';
import '../../../utiles/widgets/app_section_header.dart';
import '../../../utiles/widgets/home/featured_event_card.dart';
import '../../../utiles/widgets/home/game_spotlight_card.dart';
import '../../../utiles/widgets/home/home_hero_banner.dart';
import '../services/tournament_service.dart';
import '../../../utiles/widgets/home/live_stream_embed_card.dart';
import '../../../utiles/widgets/home/home_skeletons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<List<LiveStreamEmbed>> _mediaFuture;
  late final Future<List<FeaturedEvent>> _tournamentsFuture;

  @override
  void initState() {
    super.initState();
    _mediaFuture = MediaService.instance.fetchMediaItems();
    _tournamentsFuture = TournamentService.instance.fetchFeaturedEvents();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.instance.currentUser;

    final appBarTitle =
    (currentUser != null && currentUser.fullname.trim().isNotEmpty)
        ? currentUser.fullname.trim()
        : 'Welcome';

    final bottomPadding = MediaQuery.of(context).padding.bottom + 120;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GlassBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeroBanner(title: appBarTitle),
              const AppSectionHeader(
                title: 'Spotlight',

              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _games.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) => SizedBox(
                    width: 200,
                    child: GameSpotlightCard(game: _games[index]),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Load featured events (tournaments) from backend
              FutureBuilder<List<FeaturedEvent>>(
                future: _tournamentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSectionHeader(title: 'Featured Tournaments'),
                        Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: FeaturedEventCardSkeleton(),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: Text('Failed to load events', style: TextStyle(color: Colors.white70))),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: Text('No events available', style: TextStyle(color: Colors.white70))),
                    );
                  }
                  final events = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSectionHeader(title: 'Featured Tournaments'),
                      ...events.map((event) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FeaturedEventCard(event: event),
                      )).toList(),
                    ],
                  );
                },
              ),
              const Divider(thickness: 1, color: Colors.white10),
              const SizedBox(height: 24),
              FutureBuilder<List<LiveStreamEmbed>>(
                future: _mediaFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSectionHeader(
                          title: 'Spotlight Streams',

                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: LiveStreamEmbedCardSkeleton(),
                        ),
                      ],
                    );
                  }
                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSectionHeader(
                        title: 'Spotlight Streams',

                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: LiveStreamEmbedCard(stream: snapshot.data![index]),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const List<HomeGameSpotlight> _games = [
  HomeGameSpotlight(
    title: 'PUBG',
    subtitle: 'Battle royale ladders',
    icon: Icons.local_fire_department_rounded,
    colors: [Color(0xFF0F4C81), Color(0xFF3BA8FF)],
  ),
  HomeGameSpotlight(
    title: 'Tekken',
    subtitle: 'Fight night brackets',
    icon: Icons.sports_kabaddi_rounded,
    colors: [Color(0xFF5B1F6A), Color(0xFFD46BFF)],
  ),
  HomeGameSpotlight(
    title: 'FIFA',
    subtitle: 'Weekend duel series',
    icon: Icons.sports_soccer_rounded,
    colors: [Color(0xFF0F5A3D), Color(0xFF3AD29F)],
  ),
  HomeGameSpotlight(
    title: 'CS2',
    subtitle: 'Ranked skirmishes',
    icon: Icons.shield_outlined,
    colors: [Color(0xFF53389E), Color(0xFF8B5CF6)],
  ),
];

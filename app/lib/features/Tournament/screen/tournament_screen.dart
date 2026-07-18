import 'package:flutter/material.dart';
import '../../../theme/neumorphic_theme.dart';

import '../model/tournament_entry.dart';
import '../services/tournament_service.dart';
import 'add_tournament_screen.dart';
import '../../../utiles/widgets/tournament/tournament_entry_card.dart';
import '../../../utiles/widgets/glass/glass_kit.dart';

class TournamentScreen extends StatefulWidget {
  const TournamentScreen({super.key});

  @override
  State<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  late Future<List<TournamentEntry>> _tournamentsFuture;

  @override
  void initState() {
    super.initState();
    _tournamentsFuture = _loadTournaments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => const AddTournamentScreen(),
            ),
          );

          if (created == true) {
            setState(() {
              _tournamentsFuture = TournamentService.instance.fetchTournaments();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      body: GlassBackground(
        child: DefaultTabController(
          length: 3,
          child: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    titleSpacing: 16,
                    title: Row(
                      children: [
                        const Icon(
                          Icons.sports_esports_rounded,
                          color: Color(0xFF17B7FF),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tournaments',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none_rounded),
                      ),
                    ],
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(60),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TabBar(
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            dividerColor: Colors.transparent,
                            indicator: BoxDecoration(
                              color: kPrimaryBlue.withValues(alpha: 0.24),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: kPrimaryBlue, width: 1.0),
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: kTextMuted,
                            indicatorSize: TabBarIndicatorSize.tab,
                            tabs: const [
                              Tab(text: 'All'),
                              Tab(text: 'Upcoming'),
                              Tab(text: 'Completed'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ];
              },
            body: FutureBuilder<List<TournamentEntry>>(
              future: _tournamentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Unable to load tournaments. Please try again.',
                      style: TextStyle(color: Colors.red.shade300),
                    ),
                  );
                }

                final items = snapshot.data ?? [];
                final upcoming = items
                    .where((item) => item.status == TournamentStatus.upcoming)
                    .toList();
                final completed = items
                    .where((item) => item.status == TournamentStatus.completed)
                    .toList();

                return TabBarView(
                  children: [
                    _TournamentList(items: items),
                    _TournamentList(items: upcoming),
                    _TournamentList(items: completed),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
}

  // Helper to load tournaments with fallback dummy data
  Future<List<TournamentEntry>> _loadTournaments() async {
    try {
      final list = await TournamentService.instance.fetchTournaments();
      // If backend returns at least two items, use them directly
      if (list.length >= 2) return list;
    } catch (_) {
      // ignore errors and fall back to dummy data
    }
    // Dummy tournament entries used when API fails or returns insufficient data
    return [
      TournamentEntry(
        title: 'Demo Tournament 1',
        game: 'PUBG',
        badgeText: 'UPCOMING',
        badgeColor: const Color(0xFF17B7FF),
        schedule: 'Tomorrow 18:00 GMT',
        footerText: '\$5,000',
        actionText: 'Register',
        trailingMeta: '48 / 64',
        bannerColors: const [Color(0xFF0E5A3A), Color(0xFF39C58D)],
        metaIcon: Icons.schedule_rounded,
        status: TournamentStatus.upcoming,
        enabled: true,
        imageUrl: null,
      ),
      TournamentEntry(
        title: 'Demo Tournament 2',
        game: 'FIFA',
        badgeText: 'UPCOMING',
        badgeColor: const Color(0xFF17B7FF),
        schedule: 'Saturday 20:00 GMT',
        footerText: '\$2,500',
        actionText: 'Join',
        trailingMeta: '30 / 32',
        bannerColors: const [Color(0xFF0E5A3A), Color(0xFF39C58D)],
        metaIcon: Icons.schedule_rounded,
        status: TournamentStatus.upcoming,
        enabled: true,
        imageUrl: null,
      ),
    ];
  }
}

class _TournamentList extends StatelessWidget {
  const _TournamentList({
    required this.items,
  });

  final List<TournamentEntry> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      itemBuilder: (context, index) => TournamentEntryCard(item: items[index]),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemCount: items.length,
    );
  }
}

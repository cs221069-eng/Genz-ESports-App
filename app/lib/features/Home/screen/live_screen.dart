import 'package:flutter/material.dart';

import '../model/home_content_models.dart';
import '../model/video_feed_data.dart';
import '../services/media_service.dart';
import '../../../utiles/widgets/glass/glass_kit.dart';
import '../../../utiles/widgets/app_section_header.dart';
import '../../../utiles/widgets/home/live_stream_embed_card.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  late final Future<List<LiveStreamEmbed>> _mediaFuture;

  @override
  void initState() {
    super.initState();
    _mediaFuture = MediaService.instance.fetchMediaItems();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('LiveScreen build');
    final bottomPadding = MediaQuery.of(context).padding.bottom + 120;

    return GlassBackground(
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: FutureBuilder<List<LiveStreamEmbed>>(
                future: _mediaFuture,
                builder: (context, snapshot) {
                  final mediaItems = snapshot.data?.isNotEmpty == true
                      ? snapshot.data!
                      : videoFeedItems;
                  final liveItems = mediaItems
                      .where((item) => item.category == VideoCategory.live)
                      .toList();
                  final highlightItems = mediaItems
                      .where((item) => item.category == VideoCategory.highlight)
                      .toList();

                  return CustomScrollView(
                    slivers: [
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
                              Icons.live_tv_rounded,
                              color: Color(0xFF17B7FF),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Live & Highlights',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              GlassCard(
                                padding: const EdgeInsets.all(22),
                                borderRadius: 28,
                                color: const Color(0x2417B7FF),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Video Hub',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'All live streams and match highlights now come from your YouTube video feed.',
                                      style: TextStyle(
                                        color: Color(0xFFE6F1FF),
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (liveItems.isNotEmpty) ...[
                                const SizedBox(height: 28),
                                AppSectionHeader(
                                  title: 'Live Streaming',

                                ),
                                const SizedBox(height: 12),
                                ...liveItems.map(
                                  (item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: LiveStreamEmbedCard(stream: item),
                                  ),
                                ),
                              ],
                              if (highlightItems.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                AppSectionHeader(
                                  title: 'Highlights',

                                ),
                                const SizedBox(height: 12),
                                ...highlightItems.map(
                                  (item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: LiveStreamEmbedCard(stream: item),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

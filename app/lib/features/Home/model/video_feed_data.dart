import 'package:flutter/material.dart';

import 'home_content_models.dart';

const List<LiveStreamEmbed> videoFeedItems = [
  LiveStreamEmbed(
    title: 'Tekken 8 Competitive Live Set',
    streamer: 'GenZ Arena Live',
    viewers: '6.8K viewers',
    youtubeEmbedUrl:
        'https://www.youtube.com/embed/-Ot2QrjWCzg?si=ScrwT4ZGwUw23_13',
    thumbnailUrl: 'https://img.youtube.com/vi/-Ot2QrjWCzg/hqdefault.jpg',
    accent: Color(0xFFD9D2FF),
    badge: 'LIVE',
    category: VideoCategory.live,
  ),
  LiveStreamEmbed(
    title: 'FIFA Pro Clubs Matchday Stream',
    streamer: 'GenZ Football Arena',
    viewers: '4.1K viewers',
    youtubeEmbedUrl:
        'https://www.youtube.com/embed/-Ot2QrjWCzg?si=ScrwT4ZGwUw23_13',
    thumbnailUrl: 'https://img.youtube.com/vi/-Ot2QrjWCzg/hqdefault.jpg',
    accent: Color(0xFFCFF3DD),
    badge: 'LIVE',
    category: VideoCategory.live,
  ),
  LiveStreamEmbed(
    title: 'Tekken Community Lobby Highlights',
    streamer: 'GenZ Fight Night',
    viewers: '12 min watch',
    youtubeEmbedUrl:
        'https://www.youtube.com/embed/-Ot2QrjWCzg?si=ScrwT4ZGwUw23_13',
    thumbnailUrl: 'https://img.youtube.com/vi/-Ot2QrjWCzg/hqdefault.jpg',
    accent: Color(0xFFFFD9D2),
    badge: 'HIGHLIGHT',
    category: VideoCategory.highlight,
  ),
  LiveStreamEmbed(
    title: 'FIFA Weekend Goals and Top Plays',
    streamer: 'GenZ Highlights',
    viewers: '8 min watch',
    youtubeEmbedUrl:
        'https://www.youtube.com/embed/-Ot2QrjWCzg?si=ScrwT4ZGwUw23_13',
    thumbnailUrl: 'https://img.youtube.com/vi/-Ot2QrjWCzg/hqdefault.jpg',
    accent: Color(0xFFFFE6B8),
    badge: 'HIGHLIGHT',
    category: VideoCategory.highlight,
  ),
];

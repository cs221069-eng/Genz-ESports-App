import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../features/Home/model/home_content_models.dart';
import '../neumorphic/neumorphic_container.dart';

class LiveStreamEmbedCard extends StatelessWidget {
  const LiveStreamEmbedCard({
    super.key,
    required this.stream,
  });

  final LiveStreamEmbed stream;

  String _extractVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return url;

    if (uri.queryParameters['v'] case final videoId?) {
      return videoId;
    }

    final segments = uri.pathSegments;
    if (segments.contains('embed')) {
      final embedIndex = segments.indexOf('embed');
      if (embedIndex >= 0 && embedIndex + 1 < segments.length) {
        return segments[embedIndex + 1];
      }
    }

    return segments.isNotEmpty ? segments.last : url;
  }

  String _normalizeEmbedUrl(String url) {
    final videoId = _extractVideoId(url);
    return 'https://www.youtube.com/watch?v=$videoId';
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      borderRadius: 20,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => _YouTubePlayerScreen(
                      title: stream.title,
                      videoUrl: _normalizeEmbedUrl(stream.youtubeEmbedUrl),
                    ),
                  ),
                );
              },
              child: SizedBox(
                height: 190,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      stream.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(
                                  (Theme.of(context).scaffoldBackgroundColor.r * 255.0).round() & 0xff,
                                  (Theme.of(context).scaffoldBackgroundColor.g * 255.0).round() & 0xff,
                                  (Theme.of(context).scaffoldBackgroundColor.b * 255.0).round() & 0xff,
                                  0.6,
                                ),
                                stream.accent,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        );
                      },
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromRGBO(0, 0, 0, 0.18),
                            const Color.fromRGBO(0, 0, 0, 0.42),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Center(
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white24,
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stream.title,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 14,
                    height: 1.35,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: stream.accent.withOpacity(0.4), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: stream.accent.withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: stream.accent.withOpacity(0.2),
                        child: Icon(
                          Icons.live_tv_rounded,
                          color: stream.accent,
                          size: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        stream.streamer,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFA6C9EA),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
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

class _YouTubePlayerScreen extends StatefulWidget {
  const _YouTubePlayerScreen({
    required this.title,
    required this.videoUrl,
  });

  final String title;
  final String videoUrl;

  @override
  State<_YouTubePlayerScreen> createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<_YouTubePlayerScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Video load error: ${error.description}'),
              ),
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.videoUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: WebViewWidget(controller: _controller),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.play_circle_outline_rounded, color: Colors.white70),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Video opened in YouTube web player. Use the player controls on the page.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

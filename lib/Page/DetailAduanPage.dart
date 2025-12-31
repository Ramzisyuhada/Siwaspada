import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailAduanPage extends StatefulWidget {
  final String title;
  final String date;
  final String status;
  final String description;
  final List media;

  const DetailAduanPage({
    super.key,
    required this.title,
    required this.date,
    required this.status,
    required this.description,
    required this.media,
  });

  @override
  State<DetailAduanPage> createState() => _DetailAduanPageState();
}

class _DetailAduanPageState extends State<DetailAduanPage> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  /// ================= STATUS COLOR =================
  Color _statusColor() {
    switch (widget.status.toLowerCase()) {
      case "proses":
      case "diproses":
        return Colors.orange;
      case "selesai":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// ================= FIX URL =================
  String buildMediaUrl(String path) {
    if (path.startsWith('http')) {
      if (!path.contains(':8000')) {
        return path.replaceFirst(
          'http://192.168.1.46',
          'http://192.168.1.46:8000',
        );
      }
      return path;
    }
    return 'http://192.168.1.46:8000$path';
  }

  bool _isVideo(String url) {
    final u = url.toLowerCase();
    return u.endsWith('.mp4') || u.endsWith('.mov');
  }

  Future<void> _openVideo(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Detail Aduan",
          style: TextStyle(
            color: Color(0xff1AA4BC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= MEDIA =================
            if (widget.media.isNotEmpty)
              Column(
                children: [
                  SizedBox(
                    height: 240,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.media.length,
                      onPageChanged: (i) =>
                          setState(() => _pageIndex = i),
                      itemBuilder: (context, index) {
                        final item = widget.media[index];
                        final url = buildMediaUrl(item['path']);
                        final isVideo = _isVideo(url);

                        return GestureDetector(
                          onTap:
                              isVideo ? () => _openVideo(url) : null,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              isVideo
                                  ? Container(
                                      color: Colors.black12,
                                      child: const Center(
                                        child: Icon(
                                          Icons.play_circle_fill,
                                          size: 80,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : Image.network(
                                      url,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          Container(
                                        color: Colors.grey.shade300,
                                        child: const Icon(
                                          Icons.broken_image,
                                          size: 60,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  /// ================= DOT INDICATOR =================
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.media.length,
                      (i) => AnimatedContainer(
                        duration:
                            const Duration(milliseconds: 300),
                        margin:
                            const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _pageIndex ? 10 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: i == _pageIndex
                              ? const Color(0xff1AA4BC)
                              : Colors.grey.shade400,
                          borderRadius:
                              BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Container(
                height: 180,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.photo_library_outlined,
                        size: 60, color: Colors.grey),
                    SizedBox(height: 8),
                    Text("Tidak ada media"),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            /// ================= CONTENT =================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// DATE + STATUS
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.date,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              _statusColor().withOpacity(0.15),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _statusColor(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// DESCRIPTION
                  const Text(
                    "Deskripsi Aduan",
                    style:
                        TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

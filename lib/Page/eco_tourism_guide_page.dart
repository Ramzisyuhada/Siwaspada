import 'package:flutter/material.dart';
import 'package:siwaspada/Page/pdf_preview_page.dart';
import 'package:siwaspada/Page/video_preview_page.dart';

class EcoTourismGuidePage extends StatelessWidget {
  const EcoTourismGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),

      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Eco Tourism Guide",
          style: TextStyle(
            color: Color(0xff1AA4BC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      /// ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= DESKRIPSI =================
            const Text(
              "Panduan Ekowisata",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "Materi edukasi untuk mendukung perilaku wisata "
              "yang ramah lingkungan dan berkelanjutan.",
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 24),

            /// ================= PDF SECTION =================
            const Text(
              "📄 Materi PDF / PPT",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _guideItem(
              icon: Icons.picture_as_pdf,
              title: "Panduan Ekowisata",
              subtitle: "Baca materi PDF",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PdfPreviewPage(
                      title: "Panduan Ekowisata",
                      assetPath: "pdf/Zulham.pdf",
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            /// ================= VIDEO SECTION =================
            const Text(
              "🎥 Video Edukasi",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _guideItem(
              icon: Icons.play_circle_fill,
              title: "Pengelolaan Pariwisata",
              subtitle: "Video Edukasi",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VideoPreviewPage(
                      title: "Pengelolaan Pariwisata",
                      assetPath: "video/Pariwisata.mp4",
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ================= ITEM CARD =================
  Widget _guideItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 34, color: const Color(0xff1AA4BC)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap,
      ),
    );
  }
}

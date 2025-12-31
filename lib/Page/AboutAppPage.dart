import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),

      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Tentang Aplikasi",
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
            /// ================= LOGO =================
            Center(
              child: Column(
                children: [
                  Image.asset(
                    "Image/LogoUT.png", // pastikan ada
                    width: 120,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "UNIVERSITAS TERBUKA",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ================= TITLE =================
            const Center(
              child: Text(
                "SIWASPADA",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1AA4BC),
                ),
              ),
            ),

            const SizedBox(height: 6),

            const Center(
              child: Text(
                "Aplikasi Pengaduan dan Pengelolaan Destinasi Pariwisata",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ),

            const SizedBox(height: 30),

            /// ================= TIM PENELITI =================
            _sectionTitle("Tim Peneliti"),
            _card(
              "1. Zulham Adamy, S.H., M.H.\n"
              "   Prodi Administrasi Negara\n"
              "   Universitas Terbuka\n\n"
              "2. Gunawan Wiradharma, S.Pd., S.I.Kom., M.Si., M.Hum.\n"
              "   Prodi Ilmu Komunikasi FISIP\n"
              "   Universitas Terbuka\n\n"
              "3. Mario Aditya Prasetyo, S.Pd., S.I.Kom.\n"
              "   Pascasarjana Ilmu Komunikasi FISIP\n"
              "   Universitas Terbuka",
            ),

            const SizedBox(height: 20),

            /// ================= TIM PENGEMBANG =================
            _sectionTitle("Tim Pengembang"),
            _card(
              "1. Zaenab Diah Febriani\n"
              "2. Eriel Dantes\n"
              "3. Galih Ashari R.\n"
              "4. Ramzi Syuhada\n\n"
              "Teknologi:\n"
              "• Flutter\n"
              "• Laravel Backend\n"
              "• Vuforia\n\n"
              "Indonesia HETRA Teknologi",
            ),

            const SizedBox(height: 30),

            /// ================= FOOTER =================
            Center(
              child: Text(
                "© ${DateTime.now().year} Universitas Terbuka",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= WIDGET BANTUAN =================
  static Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  static Widget _card(String text) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          text,
          style: const TextStyle(height: 1.4),
        ),
      ),
    );
  }
}

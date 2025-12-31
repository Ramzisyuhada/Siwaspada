import 'package:flutter/material.dart';
import 'package:siwaspada/Page/zoneaware_map_page.dart';

class ZoneAwarePage extends StatelessWidget {
  final String destinasi;

 const ZoneAwarePage({
    super.key,
    required this.destinasi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),

      /// ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "ZoneAware",
          style: TextStyle(
            color: Color(0xff1AA4BC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      /// ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= LOKASI =================
            const Text(
              "Lokasi Saat Ini",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children:  [
                  Icon(Icons.location_on, color: Color(0xff1AA4BC)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      destinasi,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ================= STATUS ZONA =================
            const Text(
              "Status Zona",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _zoneCard(
              status: "WASPADA",
              color: Colors.orange,
              icon: Icons.warning_amber_rounded,
              description:
                  "Zona ini berpotensi berbahaya. Harap berhati-hati terhadap kondisi sekitar.",
            ),

            const SizedBox(height: 24),

            /// ================= DETAIL =================
            const Text(
              "Detail Informasi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _infoItem(
              icon: Icons.terrain,
              title: "Kondisi Medan",
              value: "Berbatu & licin",
            ),
            _infoItem(
              icon: Icons.cloud,
              title: "Cuaca",
              value: "Berawan, angin sedang",
            ),
            _infoItem(
              icon: Icons.people,
              title: "Aktivitas Pengunjung",
              value: "Ramai",
            ),

            const SizedBox(height: 28),

            /// ================= REKOMENDASI =================
            const Text(
              "Rekomendasi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xffFFF3E0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                "• Gunakan alas kaki yang aman\n"
                "• Hindari area tepi tebing\n"
                "• Perhatikan perubahan cuaca\n"
                "• Ikuti arahan petugas",
                style: TextStyle(height: 1.5),
              ),
            ),

            const SizedBox(height: 32),

            /// ================= BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ZoneAwarePlacesPage(),
      ),
    );
  },
  icon: const Icon(Icons.map),
  label: const Text("Lihat Peta Zona"),
)
,
            ),
          ],
        ),
      ),
    );
  }

  /// ================= ZONE CARD =================
  Widget _zoneCard({
    required String status,
    required Color color,
    required IconData icon,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, size: 60, color: color),
          const SizedBox(height: 12),
          Text(
            status,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= INFO ITEM =================
  Widget _infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xff1AA4BC)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(title),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:siwaspada/Page/DetailAduanPage.dart';
import 'package:siwaspada/Service/AuthStorage.dart';
import 'package:siwaspada/Service/ComplaintService.dart';

/// ================= ENUM MODE =================
enum AduanListType {
  masyarakat,
  milikSaya,
}

/// ================= PAGE =================
class ListAduanPage extends StatefulWidget {
  final AduanListType type;

  const ListAduanPage({
    super.key,
    required this.type,
  });

  @override
  State<ListAduanPage> createState() => _ListAduanPageState();
}

class _ListAduanPageState extends State<ListAduanPage> {
late Future<List<dynamic>> futureAduan =
    ComplaintService.getAllComplaints();

  bool get isMilikSaya => widget.type == AduanListType.milikSaya;

  @override
  void initState() {
    super.initState();
  _loadData();


  }
void _loadData() async {
  final idUser = await AuthStorage.getUserId();
  final idTour = await AuthStorage.getTourId();

  setState(() {
    futureAduan = isMilikSaya
        ? ComplaintService.getComplaintByUserAndTour(
             idUser!,
           idTour!,
          )
        : ComplaintService.getAllComplaints();
  });
}
  /// ================= IMAGE URL FIX =================
  String buildImageUrl(String path) {
    if (path.startsWith('http')) {
      if (!path.contains(':8000')) {
        return path.replaceFirst(
          'http://192.168.1.46',
          'http://192.168.1.46:8000',
        );
      }
      return path;
    }
    return "http://192.168.1.46:8000$path";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),

      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          isMilikSaya ? "Riwayat Aduan Ku" : "Aduan Masyarakat",
          style: const TextStyle(
            color: Color(0xff1AA4BC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      /// ================= BODY =================
      body: FutureBuilder<List<dynamic>>(
        future: futureAduan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final aduanList = snapshot.data ?? [];

          if (aduanList.isEmpty) {
            return const Center(child: Text("Belum ada aduan"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: aduanList.length,
            itemBuilder: (context, index) {
              final aduan = aduanList[index];
              final List media = aduan['media'] ?? [];

              final imageUrl = media.isNotEmpty
                  ? buildImageUrl(media.first['path'])
                  : null;

              return AduanCard(
                imageUrl: imageUrl,
                title: aduan['complaint'],
                date: aduan['complaint_date']
                    .toString()
                    .substring(0, 10),
                status: aduan['status'],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailAduanPage(
                        title: aduan['complaint'],
                        date: aduan['complaint_date']
                            .toString()
                            .substring(0, 10),
                        status: aduan['status'],
                        description: aduan['complaint'],
                        media: media,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// ================= CARD =================
class AduanCard extends StatelessWidget {
  final String title;
  final String date;
  final String status;
  final String? imageUrl;
  final VoidCallback onTap;

  const AduanCard({
    super.key,
    required this.title,
    required this.date,
    required this.status,
    this.imageUrl,
    required this.onTap,
  });

  Color _statusColor() {
    switch (status.toLowerCase()) {
      case "proses":
        return Colors.orange;
      case "selesai":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
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
          children: [
            /// IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey.shade300,
                        child:
                            const Icon(Icons.broken_image, size: 32),
                      ),
                    )
                  : Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, size: 32),
                    ),
            ),

            const SizedBox(width: 12),

            /// CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),

                  /// STATUS
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor().withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _statusColor(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

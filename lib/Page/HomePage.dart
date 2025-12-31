import 'package:flutter/material.dart';
import 'package:siwaspada/Page/CuacaPage.dart';
import 'package:siwaspada/Page/DetailAduanPage.dart';
import 'package:siwaspada/Page/ProfilePage.dart';
import 'package:siwaspada/Page/SkorPage.dart';
import 'package:siwaspada/Page/TambahAduanPage.dart';
import 'package:siwaspada/Page/eco_tourism_guide_page.dart';
import 'package:siwaspada/Page/list_aduan_page.dart';
import 'package:siwaspada/Page/zoneaware_page.dart';
import 'package:siwaspada/Service/ComplaintService.dart';
import 'package:siwaspada/Widget/AduanItem.dart';
import 'package:siwaspada/Widget/CorouselWidget.dart';
import 'package:siwaspada/Widget/CustomButtonNav';
import 'package:siwaspada/Widget/MenuCard.dart';
import 'package:siwaspada/Widget/SearchFieldWidget.dart';

class Homepage extends StatefulWidget {
  final String destinasi;
  final int idTour;

  const Homepage({
    super.key,
    required this.destinasi,
    required this.idTour,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;

  final List<String> dataGambar = [
    "Image/bukit1.jpg",
    "Image/bukit2.jpg",
    "Image/bukit3.jpg",
  ];

  late Future<List<dynamic>> futureAduan;

  @override
  void initState() {
    super.initState();
    _loadAduan();
  }

  void _loadAduan() {
    futureAduan = ComplaintService.getAllComplaints();
  }

  /// ================= FIX URL MEDIA =================
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

  bool _isImage(String url) {
    final u = url.toLowerCase();
    return u.endsWith('.jpg') || u.endsWith('.jpeg') || u.endsWith('.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "SIWASPADA",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff1AA4BC),
          ),
        ),
      ),

      /// ================= BODY =================
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => _loadAduan());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================= CAROUSEL =================
              SizedBox(
                height: 230,
                child: Stack(
                  children: [
                    Corouselwidget(dataGambar: dataGambar),
                    Positioned(
                      top: 170,
                      left: 20,
                      right: 20,
                      child: Searchfieldwidget(
                        hintText: "Cari destinasi",
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ================= GRID MENU =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    MenuCard(
                      imagePath: "Image/achievement.png",
                      title: "Score",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SkorPage(
                              idTour: widget.idTour,
                              namaTour: widget.destinasi,
                            ),
                          ),
                        );
                      },
                    ),
                    MenuCard(
                      imagePath: "Image/guidebook.png",
                      title: "EcoTourism Guide",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EcoTourismGuidePage(),
                          ),
                        );
                      },
                    ),
                    MenuCard(
                      imagePath: "Image/cloudy.png",
                      title: "Cuaca",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CuacaPage(),
                          ),
                        );
                      },
                    ),
                    MenuCard(
                      imagePath: "Image/zone.png",
                      title: "ZoneAware",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ZoneAwarePage(
                              destinasi: widget.destinasi,
                            ),
                          ),
                        );
                      },
                    ),
                    MenuCard(
                      imagePath: "Image/clock.png",
                      title: "Aduan Ku",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ListAduanPage(
                              type: AduanListType.milikSaya,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// ================= ADUAN TERBARU =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Aduan Terbaru",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ListAduanPage(
                              type: AduanListType.masyarakat,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Lihat Semua >",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff1AA4BC),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// ================= LIST ADUAN =================
              FutureBuilder<List<dynamic>>(
                future: futureAduan,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }

                  final aduanList = snapshot.data ?? [];
                  final tampilAduan = aduanList.take(3).toList();

                  if (tampilAduan.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("Belum ada aduan"),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: tampilAduan.map((aduan) {
                        final List media = aduan['media'] ?? [];

                        String imagePath = "Image/bukit1.jpg";

                        if (media.isNotEmpty) {
                          final url = buildMediaUrl(media.first['path']);
                          if (_isImage(url)) {
                            imagePath = url;
                          }
                        }

                        return AduanItem(
                          imagePath: imagePath,
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
                      }).toList(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      /// ================= BOTTOM NAV =================
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TambahAduanPage()),
            ).then((_) {
              setState(() => _loadAduan());
            });
          }else if(index == 2){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }
        },
      ),
    );
  }
}

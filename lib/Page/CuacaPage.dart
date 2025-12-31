import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:siwaspada/Model/CuacaModel.dart';
import 'package:siwaspada/Service/bmkg_weather_service.dart';

class CuacaPage extends StatefulWidget {
  const CuacaPage({super.key});

  @override
  State<CuacaPage> createState() => _CuacaPageState();
}

class _CuacaPageState extends State<CuacaPage> {
  late Future<List<CuacaModel>> futureCuaca;

  final String adm4 = "51.71.01.1001";
  final String lokasiText = "Serangan, Denpasar Selatan";

  @override
  void initState() {
    super.initState();
    futureCuaca = BmkgWeatherService.fetchCuaca(adm4);
  }

  Future<void> _refresh() async {
    setState(() {
      futureCuaca = BmkgWeatherService.fetchCuaca(adm4);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        title: const Text(
          "Cuaca",
          style: TextStyle(color: Color(0xff1AA4BC)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<CuacaModel>>(
        future: futureCuaca,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Terjadi kesalahan\n${snapshot.error}"),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Data cuaca tidak tersedia"));
          }

          final cuaca = snapshot.data!;
          final int showCount = cuaca.length >= 6 ? 6 : cuaca.length;
          final now = cuaca.first;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// ================= RINGKASAN CUACA =================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SvgPicture.network(
                          now.iconUrl,
                          width: 60,
                          height: 60,
                          placeholderBuilder: (_) =>
                              const Icon(Icons.cloud, size: 60),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lokasiText,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "${now.temp}°C",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              now.condition,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// ================= INFO TAMBAHAN =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _infoItem("Kelembaban", "${now.humidity}%"),
                      _infoItem("Angin", "${now.windSpeed} km/j"),
                    ],
                  ),

                  const SizedBox(height: 28),

                  /// ================= PER JAM =================
                  const Text(
                    "Perkiraan Cuaca Per Jam",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 135,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: showCount,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, i) {
                        final c = cuaca[i];
                        return Container(
                          width: 95,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${c.time.hour.toString().padLeft(2, '0')}:00",
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 6),
                              SvgPicture.network(
                                c.iconUrl,
                                width: 42,
                                height: 42,
                                placeholderBuilder: (_) =>
                                    const Icon(Icons.cloud),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "${c.temp}°C",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// ================= GRAFIK =================
                  const Text(
                    "Grafik Temperatur",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 220,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(show: true),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: cuaca
                                .take(showCount)
                                .toList()
                                .asMap()
                                .entries
                                .map(
                                  (e) => FlSpot(
                                    e.key.toDouble(),
                                    e.value.temp.toDouble(),
                                  ),
                                )
                                .toList(),
                            isCurved: true,
                            dotData: FlDotData(show: true),
                            color: Colors.orange,
                            barWidth: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}

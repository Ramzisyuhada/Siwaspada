import 'package:flutter/material.dart';
import 'package:siwaspada/Page/DetailAduanPage.dart';
import 'package:siwaspada/Service/AdminComplaintService.dart';

class AdminListAduanPage extends StatefulWidget {
  final int idTour;

  const AdminListAduanPage({
    super.key,
    required this.idTour,
  });

  @override
  State<AdminListAduanPage> createState() => _ListAduanPageState();
}

class _ListAduanPageState extends State<AdminListAduanPage> {
  late Future<List<dynamic>> futureAduan;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    futureAduan =
        AdminComplaintService.getComplaintsByTour(widget.idTour);
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.grey;
      case 'proses':
        return Colors.orange;
      case 'selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _safeStatus(dynamic status) {
    if (status == null || status.toString().isEmpty) {
      return "pending";
    }
    return status.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Admin - Daftar Aduan",
          style: TextStyle(
            color: Color(0xff1AA4BC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() => _loadData()),
        child: FutureBuilder<List<dynamic>>(
          future: futureAduan,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                  child: Text("Error: ${snapshot.error}"));
            }

            final list = snapshot.data ?? [];

            if (list.isEmpty) {
              return const Center(
                  child: Text("Belum ada aduan"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final aduan = list[index];
                final status = _safeStatus(aduan['status']);

                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailAduanPage(
                          title:
                              aduan['user']['username'] ??
                                  "-",
                          date: aduan['complaint_date']
                                  ?.toString()
                                  .substring(0, 10) ??
                              "-",
                          status:
                              aduan['status'] ?? "pending",
                          description:
                              aduan['complaint'] ?? "-",
                          media: aduan['media'] ?? [],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                            children: [
                              Text(
                                aduan['user']['username'] ??
                                    "-",
                                style: const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              Text(
                                aduan['complaint_date']
                                        ?.toString()
                                        .substring(
                                            0, 10) ??
                                    "-",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            aduan['complaint'] ?? "-",
                            maxLines: 2,
                            overflow:
                                TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                            children: [
                              Chip(
                                label: Text(
                                  status,
                                  style: TextStyle(
                                    color:
                                        _statusColor(
                                            status),
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                backgroundColor:
                                    _statusColor(status)
                                        .withOpacity(
                                            0.15),
                              ),
                              DropdownButton<String>(
                                value: status,
                                underline:
                                    const SizedBox(),
                                items: const [
                                  DropdownMenuItem(
                                    value: "pending",
                                    child:
                                        Text("Pending"),
                                  ),
                                  DropdownMenuItem(
                                    value: "proses",
                                    child:
                                        Text("Proses"),
                                  ),
                                  DropdownMenuItem(
                                    value: "selesai",
                                    child:
                                        Text("Selesai"),
                                  ),
                                ],
                                onChanged:
                                    (value) async {
                                  if (value ==
                                      null) return;

                                  await AdminComplaintService
                                      .updateStatus(
                                    idComplaint: aduan[
                                        'id_complaint'],
                                    status: value,
                                  );

                                  setState(() =>
                                      _loadData());
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

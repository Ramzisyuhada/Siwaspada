import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:siwaspada/Service/AuthStorage.dart';
import 'package:siwaspada/config/api_config.dart';

class AdminComplaintService {
  static Future<List<dynamic>> getComplaintsByTour(int idTour) async {
    final token = await AuthStorage.getToken();

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/admin/complaints/tour/$idTour'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return body['data'] ?? [];
    } else {
      throw Exception(body['message'] ?? 'Gagal mengambil data aduan');
    }
  }

  static Future<void> updateStatus({
    required int idComplaint,
    required String status,
  }) async {
    final token = await AuthStorage.getToken();

    final response = await http.put(
Uri.parse(
      "${ApiConfig.baseUrl}/admin/complaints/$idComplaint/status",
    ),      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal update status');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:siwaspada/Service/AuthStorage.dart';
import 'package:siwaspada/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingService {
static Future<List<dynamic>> getByTour(int idTour) async {
  final token = await AuthStorage.getToken();

  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/ratings/tour/$idTour'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  /// ================= SUKSES =================
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return json['data'] ?? [];
  }

  /// ================= DATA KOSONG =================
  if (response.statusCode == 404) {
    // anggap rating belum ada
    return [];
  }

  /// ================= TOKEN EXPIRED =================
  if (response.statusCode == 401) {
    throw Exception('Unauthenticated');
  }

  /// ================= ERROR LAIN =================
  throw Exception('Gagal mengambil rating (${response.statusCode})');
}


  static Future<void> submitRating({
    required int value,
    required String comment,
  }) async {
    final prefs = await SharedPreferences.getInstance();
  final token = await AuthStorage.getToken();

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/ratings'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'value': value.toString(),
        'comment': comment,
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal kirim rating');
    }
  }
}

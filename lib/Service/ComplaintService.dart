import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:siwaspada/Service/AuthStorage.dart';
import 'package:siwaspada/config/api_config.dart';

class ComplaintService {
  /// ================= HEADER =================
  static Future<Map<String, String>> _headers() async {
    final token = await AuthStorage.getToken();

    if (token == null) {
      throw Exception("Token tidak ditemukan, silakan login ulang");
    }

    return {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    };
  }

  /// ================= ADUAN MASYARAKAT =================
  static Future<List<dynamic>> getAllComplaints() async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/complaints"),
      headers: await _headers(),
    );

    final body = json.decode(response.body);

    if (response.statusCode == 200) {
      return body['data'] ?? [];
    } else {
      throw Exception(body['message'] ?? "Gagal mengambil aduan masyarakat");
    }
  }

  /// ================= ADUAN MILIK SAYA =================
  /// Endpoint backend:
  /// GET /complaints/user/{id_users}
  static Future<List<dynamic>> getComplaintByUserAndTour(
  int idUsers,
  int idTour,
) async {
  final token = await AuthStorage.getToken();

  if (token == null) {
    throw Exception("Token tidak ditemukan, silakan login ulang");
  }

  final response = await http.get(
    Uri.parse(
      "${ApiConfig.baseUrl}/complaints/user/$idUsers/tour/$idTour",
    ),
    headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    },
  );

  final body = json.decode(response.body);

  if (response.statusCode == 200) {
    return body['data'] ?? [];
  } else if (response.statusCode == 404) {
    // penting: JANGAN throw error biar UI aman
    return [];
  } else {
    throw Exception(body['message'] ?? "Gagal mengambil aduan user");
  }
}

static Future<void> addComplaint({
    required String complaint,
    required double latitude,
    required double longitude,
    required String completeAddress,
    List<File>? mediaFiles,
  }) async {
    final uri = Uri.parse("${ApiConfig.baseUrl}/complaints");
    final request = http.MultipartRequest("POST", uri);

    request.headers.addAll(await _headers());

    request.fields.addAll({
      "complaint": complaint,
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "complete_address": completeAddress,
    });

    // media (optional)
    if (mediaFiles != null) {
      for (var file in mediaFiles) {
        request.files.add(
          await http.MultipartFile.fromPath("media[]", file.path),
        );
      }
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final body = json.decode(responseBody);

    if (response.statusCode != 201) {
      throw Exception(body['message'] ?? "Gagal menambahkan aduan");
    }
  }
}

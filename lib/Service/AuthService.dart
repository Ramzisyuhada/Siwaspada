import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:siwaspada/Service/AuthStorage.dart';
import 'package:siwaspada/config/api_config.dart';

class AuthService {
  /// ================= LOGIN =================
  static Future<void> login({
    required String username,
    required String password,
    required int idTour,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/login"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "password": password,
        "id_tour": idTour,
      }),
    );

    final body = json.decode(response.body);

   if (response.statusCode == 200) {
      final token = body['data']['token'];
      await AuthStorage.saveToken(token);
      await AuthStorage.saveTourId(idTour);
      await AuthStorage.saveUserId(body['data']['user']['id_users']);
      await AuthStorage.saveRole(body['data']['user']['role']);

      await AuthStorage.saveUserneme(username);

    } else {
      throw Exception(body['message'] ?? "Login gagal");
    }
  }

  /// ================= REGISTER =================
  static Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/register"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
      }),
    );

    final body = json.decode(response.body);

    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? "Register gagal");
    }
  }
}

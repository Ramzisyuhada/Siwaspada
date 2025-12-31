import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:siwaspada/Model/zone_model.dart';

class ZoneService {
  static Future<List<ZoneModel>> fetchZones() async {
    final response = await http.get(
      Uri.parse("https://YOUR_API_URL/zones"),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData['zones'] as List)
          .map((e) => ZoneModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Gagal memuat zona");
    }
  }
}

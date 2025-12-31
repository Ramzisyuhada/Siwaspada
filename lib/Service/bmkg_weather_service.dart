import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/CuacaModel.dart';

class BmkgWeatherService {
  static const String _baseUrl =
      "https://api.bmkg.go.id/publik/prakiraan-cuaca";

  static Future<List<CuacaModel>> fetchCuaca(String adm4) async {
    final url = Uri.parse("$_baseUrl?adm4=$adm4");
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Gagal mengambil data cuaca BMKG");
    }

    final decoded = jsonDecode(response.body);

    /// ambil cuaca (LIST BERSARANG)
    final List cuacaNested = decoded['data'][0]['cuaca'];

    /// FLATTEN → List<Map>
    final List cuacaFlat = cuacaNested.expand((e) => e).toList();

    /// MAP KE MODEL
    return cuacaFlat.map((e) => CuacaModel.fromJson(e)).toList();
  }
}

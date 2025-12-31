class CuacaModel {
  final DateTime time;
  final int temp;
  final String condition;
  final String iconUrl;

  final int humidity;      // ⬅️ HU dari BMKG
  final double windSpeed;  // ⬅️ WS dari BMKG

  CuacaModel({
    required this.time,
    required this.temp,
    required this.condition,
    required this.iconUrl,
    required this.humidity,
    required this.windSpeed,
  });

  factory CuacaModel.fromJson(Map<String, dynamic> json) {
    return CuacaModel(
      time: DateTime.parse(json['local_datetime']),
      temp: json['t'],
      condition: json['weather_desc'],
      iconUrl: json['image'],
      humidity: json['hu'],              // BMKG: hu
      windSpeed: (json['ws'] as num).toDouble(), // BMKG: ws
    );
  }
}

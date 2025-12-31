class ZoneModel {
  final String id;
  final String name;
  final String level;
  final List<LatLngPoint> points;

  ZoneModel({
    required this.id,
    required this.name,
    required this.level,
    required this.points,
  });

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
      id: json['id'],
      name: json['name'],
      level: json['level'],
      points: (json['coordinates'] as List)
          .map((e) => LatLngPoint.fromJson(e))
          .toList(),
    );
  }
}

class LatLngPoint {
  final double lat;
  final double lng;

  LatLngPoint({required this.lat, required this.lng});

  factory LatLngPoint.fromJson(Map<String, dynamic> json) {
    return LatLngPoint(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

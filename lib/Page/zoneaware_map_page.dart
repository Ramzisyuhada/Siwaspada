import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class ZoneAwarePlacesPage extends StatefulWidget {
  const ZoneAwarePlacesPage({super.key});

  @override
  State<ZoneAwarePlacesPage> createState() => _ZoneAwarePlacesPageState();
}

class _ZoneAwarePlacesPageState extends State<ZoneAwarePlacesPage> {
  LatLng? _userLocation;
  final Set<Marker> _markers = {};

  final String apiKey = "API_KEY_KAMU";

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Geolocator.requestPermission();
    final pos = await Geolocator.getCurrentPosition();
    _userLocation = LatLng(pos.latitude, pos.longitude);
    await _fetchNearbyPlaces();
    setState(() {});
  }

  /// ================= FETCH PLACES =================
  Future<void> _fetchNearbyPlaces() async {
    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        "?location=${_userLocation!.latitude},${_userLocation!.longitude}"
        "&radius=100"
        "&type=mosque|restaurant|toilet"
        "&key=$apiKey";

    final res = await http.get(Uri.parse(url));
    final data = json.decode(res.body);

    for (var p in data['results']) {
      final LatLng pos = LatLng(
        p['geometry']['location']['lat'],
        p['geometry']['location']['lng'],
      );

      final List types = p['types'];

      String zoneType = _mapType(types);

      _markers.add(
        Marker(
          markerId: MarkerId(p['place_id']),
          position: pos,
          infoWindow: InfoWindow(
            title: p['name'],
            onTap: () => _showZoneDialog(zoneType),
          ),
        ),
      );
    }
  }

  /// ================= MAP PLACE TYPE =================
  String _mapType(List types) {
    if (types.contains("mosque")) return "masjid";
    if (types.contains("toilet") || types.contains("restroom")) {
      return "toilet";
    }
    if (types.contains("restaurant") || types.contains("food")) {
      return "restaurant";
    }
    return "other";
  }

  /// ================= ZONE DIALOG =================
  void _showZoneDialog(String type) {
    Map<String, List<String>> aturan = {
      "masjid": [
        "Jaga ketenangan",
        "Berpakaian sopan",
        "Matikan suara HP",
      ],
      "toilet": [
        "Jaga kebersihan",
        "Siram setelah digunakan",
        "Buang sampah pada tempatnya",
      ],
      "restaurant": [
        "Antri dengan tertib",
        "Jaga kebersihan meja",
        "Hormati pengunjung lain",
      ],
    };

    if (!aturan.containsKey(type)) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          type == "masjid"
              ? "Zona Masjid"
              : type == "toilet"
                  ? "Zona Toilet Umum"
                  : "Zona Restoran",
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: aturan[type]!
              .map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text("• $e"),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Mengerti"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ZoneAware (Places API)"),
        centerTitle: true,
      ),
      body: _userLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _userLocation!,
                zoom: 17,
              ),
              myLocationEnabled: true,
              markers: _markers,
            ),
    );
  }
}

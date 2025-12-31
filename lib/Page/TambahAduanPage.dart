import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:siwaspada/Service/ComplaintService.dart';

class TambahAduanPage extends StatefulWidget {
  const TambahAduanPage({super.key});

  @override
  State<TambahAduanPage> createState() => _TambahAduanPageState();
}

class _TambahAduanPageState extends State<TambahAduanPage> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _catatanController = TextEditingController();

  final List<XFile> _mediaList = [];
  final int maxMedia = 3;

  bool _isLoading = false;

  /// ================= DUMMY LOKASI =================
  final double _latitude = -8.895;
  final double _longitude = 116.284;

  /// ================= PICK MEDIA =================
  Future<void> _pickMedia(ImageSource source, {bool isVideo = false}) async {
    if (_mediaList.length >= maxMedia) {
      _snack("Maksimal 3 media");
      return;
    }

    final XFile? picked = isVideo
        ? await _picker.pickVideo(source: source)
        : await _picker.pickImage(source: source, imageQuality: 80);

    if (picked != null) {
      // batas ukuran video 50MB
      final size = await File(picked.path).length();
      final sizeMB = size / (1024 * 1024);
      if (isVideo && sizeMB > 50) {
        _snack("Video maksimal 50MB");
        return;
      }

      setState(() => _mediaList.add(picked));
    }
  }

  void _showPickOption() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Foto dari Kamera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Foto dari Galeri"),
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text("Video dari Galeri"),
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(ImageSource.gallery, isVideo: true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isVideo(XFile file) {
    final p = file.path.toLowerCase();
    return p.endsWith('.mp4') || p.endsWith('.mov');
  }

  /// ================= SUBMIT =================
  Future<void> _submitAduan() async {
    if (_mediaList.isEmpty || _catatanController.text.isEmpty) {
      _snack("Media & catatan wajib diisi");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ComplaintService.addComplaint(
        complaint: _catatanController.text,
        latitude: _latitude,
        longitude: _longitude,
        completeAddress: "Lokasi laporan pengguna",
        mediaFiles: _mediaList.map((e) => File(e.path)).toList(),
      );

      if (!mounted) return;
      _showSuccessDialog();
    } catch (e) {
      _snack(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  /// ================= SUCCESS =================
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle,
                  color: Color(0xff1AA4BC), size: 64),
              const SizedBox(height: 16),
              const Text("Berhasil",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              const Text("Aduan berhasil dikirim",
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      },
    );
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF6F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Aduan Singkat",
          style: TextStyle(
            color: Color(0xff1AA4BC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Media"),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ..._mediaList.map((file) => _mediaItem(file)),
                    if (_mediaList.length < maxMedia)
                      InkWell(
                        onTap: _showPickOption,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _catatanController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: "Masukkan catatan aduan",
                    filled: true,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitAduan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1AA4BC),
                    ),
                    child: const Text("KIRIM"),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  /// ================= MEDIA ITEM =================
  Widget _mediaItem(XFile file) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: _isVideo(file)
              ? Container(
                  width: 100,
                  height: 100,
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(Icons.play_circle_fill,
                        color: Colors.white, size: 40),
                  ),
                )
              : Image.file(
                  File(file.path),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => setState(() => _mediaList.remove(file)),
            child: const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.black54,
              child: Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

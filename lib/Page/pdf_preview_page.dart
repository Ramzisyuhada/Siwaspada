import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PdfPreviewPage extends StatefulWidget {
  final String title;
  final String assetPath; // ⬅ PDF dari asset

  const PdfPreviewPage({
    super.key,
    required this.title,
    required this.assetPath,
  });

  @override
  State<PdfPreviewPage> createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdfFromAsset();
  }

  /// ================= LOAD PDF FROM ASSET =================
  Future<void> _loadPdfFromAsset() async {
    try {
      // Load bytes dari asset
      final bytes = await rootBundle.load(widget.assetPath);

      // Simpan ke temporary directory
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${widget.assetPath.split('/').last}');
      await file.writeAsBytes(bytes.buffer.asUint8List());

      setState(() {
        localPath = file.path;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memuat PDF")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),

      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Color(0xff1AA4BC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      /// ================= BODY =================
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : localPath == null
              ? const Center(child: Text("PDF tidak tersedia"))
              : PDFView(
                  filePath: localPath!,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: false,
                  pageFling: true,
                ),
    );
  }
}

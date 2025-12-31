import 'package:flutter/material.dart';
import 'package:siwaspada/Page/AdminComplaintPage.dart';
import 'package:siwaspada/Service/AuthStorage.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
            color: Color(0xff1AA4BC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.list_alt),
          label: const Text("Kelola Aduan"),
          onPressed: () async {
            final idTour = await AuthStorage.getTourId();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AdminListAduanPage(idTour: idTour!),
              ),
            );
          },
        ),
      ),
    );
  }
}

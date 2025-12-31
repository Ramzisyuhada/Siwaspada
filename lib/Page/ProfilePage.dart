import 'package:flutter/material.dart';
import 'package:siwaspada/Page/AboutAppPage.dart';
import 'package:siwaspada/Page/LoginPage.dart';
import 'package:siwaspada/Page/list_aduan_page.dart';
import 'package:siwaspada/Service/AuthStorage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "-";
  String destinasi = "-";
  bool isLoading = true;

  final Map<int, String> destinasiMap = {
    1: "Kute",
    2: "Pantai",
    3: "Mandalika",
  };

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final name = await AuthStorage.getUsername();
    final tourId = await AuthStorage.getTourId();

    setState(() {
      username = name ?? "-";
      destinasi = destinasiMap[tourId] ?? "-";
      isLoading = false;
    });
  }

  Future<void> _logout() async {
    await AuthStorage.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Profil",
          style: TextStyle(
            color: Color(0xff1AA4BC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),

          CircleAvatar(
            radius: 55,
            backgroundColor: const Color(0xff1AA4BC).withOpacity(0.15),
            child: const Icon(Icons.person, size: 60, color: Color(0xff1AA4BC)),
          ),

          const SizedBox(height: 16),

          Text(
            username,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Chip(
            label: Text(destinasi),
            backgroundColor: const Color(0xff1AA4BC).withOpacity(0.1),
            labelStyle: const TextStyle(
              color: Color(0xff1AA4BC),
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _menuItem(
                  icon: Icons.list_alt,
                  title: "Aduan Saya",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ListAduanPage(
                          type: AduanListType.milikSaya,
                        ),
                      ),
                    );
                  },
                ),
                _menuItem(
                  icon: Icons.logout,
                  title: "Logout",
                  color: Colors.red,
                  onTap: _logout,
                ),
                _menuItem(
  icon: Icons.info_outline,
  title: "Tentang Aplikasi",
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AboutAppPage(),
      ),
    );
  },
),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    Color color = Colors.black,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(color: color)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap,
      ),
    );
  }
}

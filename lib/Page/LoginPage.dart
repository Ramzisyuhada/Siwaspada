import 'package:flutter/material.dart';
import 'package:siwaspada/Page/AdminHomePage.dart';
import 'package:siwaspada/Page/DaftarPage.dart';
import 'package:siwaspada/Page/HomePage.dart';
import 'package:siwaspada/Service/AuthService.dart';
import 'package:siwaspada/Service/AuthStorage.dart';
import 'package:siwaspada/Widget/ButtonCustom.dart';
import 'package:siwaspada/Widget/CostumInputField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String username = "";
  String password = "";
  String destinasi = "";

  /// ================= MAP DESTINASI -> ID TOUR =================
  final Map<String, int> destinasiMap = {
    "Kute": 1,
    "Pantai": 2,
    "Mandalika": 3,
  };

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          /// ================= FORM LOGIN =================
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 39),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),

                    /// LOGO
                    Center(
                      child: Image.asset(
                        "Image/LogoUT.png",
                        width: 120,
                        height: 120,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Login untuk mengakses aduan Anda",
                      style: TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 20),

                    /// USERNAME
                    Costuminputfield(
                      hintText: "Username",
                      iconData: Icons.person,
                      onChanged: (value) => username = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Username wajib diisi";
                        }
                        return null;
                      },
                    ),

                    /// PASSWORD
                    Costuminputfield(
                      hintText: "Password",
                      iconData: Icons.lock,
                      isPassword: true,
                      onChanged: (value) => password = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password wajib diisi";
                        }
                        if (value.length < 6) {
                          return "Password minimal 6 karakter";
                        }
                        return null;
                      },
                    ),

                    /// DESTINASI
                    Costuminputfield(
                      hintText: "Destinasi",
                      iconData: Icons.arrow_drop_down,
                      comboBox: true,
                      items: destinasiMap.keys.toList(),
                      onChanged: (value) => destinasi = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Destinasi harus dipilih";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 40),

                    /// BUTTON LOGIN
                    Buttoncustom(
                      textButton: "Masuk",
                      datacolor: const Color(0xffD7D7D7),
                      dataColorText: const Color(0xff000000),
                      ValueRadius: 10,
                      onPressed: isLoading
    ? null
    : () async {
        if (_formKey.currentState!.validate()) {
          setState(() => isLoading = true);

          try {
            final int idTour = destinasiMap[destinasi]!;

            await AuthService.login(
              username: username,
              password: password,
              idTour: idTour,
            );

            final role = await AuthStorage.getRole();

            if (!mounted) return;

            if (role == 'admin') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminHomePage(),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => Homepage(
                    destinasi: destinasi,
                    idTour: idTour,
                  ),
                ),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          } finally {
            setState(() => isLoading = false);
          }
        }
      },

                    ),

                    const SizedBox(height: 16),

                    /// LINK DAFTAR
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Belum punya akun? "),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const DaftarPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Daftar",
                              style:
                                  TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),

          /// ================= LOADING OVERLAY =================
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xff1AA4BC),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

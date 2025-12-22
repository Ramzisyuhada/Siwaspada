import 'package:flutter/material.dart';
import 'package:siwaspada/Page/DaftarPage.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
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
                  items: const ["Kute", "Pantai", "Mandalika"],
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
                  dataColorText: Color(0XFF000000),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      debugPrint("LOGIN BERHASIL");
                      debugPrint("Username: $username");
                      debugPrint("Password: $password");
                      debugPrint("Destinasi: $destinasi");

                      // TODO:
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (_) => const HomePage()),
                      // );
                    }
                  },
                  ValueRadius: 10,
                ),

                const SizedBox(height: 16),

                /// LINK DAFTAR (TANPA VALIDASI)
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
                              builder: (context) => const DaftarPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Daftar",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}

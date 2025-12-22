import 'package:flutter/material.dart';
import 'package:siwaspada/Page/LoginPage.dart';
import 'package:siwaspada/Widget/ButtonCustom.dart';
import 'package:siwaspada/Widget/CostumInputField.dart';

class DaftarPage extends StatefulWidget {
  const DaftarPage({super.key});

  @override
  State<DaftarPage> createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  final _formKey = GlobalKey<FormState>();

  String username = "";
  String password = "";
  String confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(

        title: const Text("Daftar Akun"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 39),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Center(
                  child: Image.asset(
                    "Image/LogoUT.png",
                    width: 120,
                    height: 120,
                  ),
                ),
                const SizedBox(height: 30),
                Text("Lengkapi data diri Anda."),
                const SizedBox(height: 30),

                /// USERNAME
                Costuminputfield(
                  hintText: "Username",
                  iconData: Icons.person,
                  onChanged: (v) => username = v,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Username wajib diisi";
                    }
                    return null;
                  },
                ),
                  Costuminputfield(
                  hintText: "Email",
                  iconData: Icons.mail,
                  onChanged: (v) => username = v,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
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
                  onChanged: (v) => password = v,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Password wajib diisi";
                    }
                    if (v.length < 6) {
                      return "Password minimal 6 karakter";
                    }
                    return null;
                  },
                ),

                /// KONFIRMASI PASSWORD
                Costuminputfield(
                  hintText: "Konfirmasi Password",
                  iconData: Icons.lock_outline,
                  isPassword: true,
                  onChanged: (v) => confirmPassword = v,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Konfirmasi password wajib diisi";
                    }
                    if (v != password) {
                      return "Password tidak sama";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                /// BUTTON DAFTAR
                Buttoncustom(
                  textButton: "Daftar",
                  datacolor: const Color(0xff1AA4BC),
                  dataColorText: Color(0xFFFFFFFFFF),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      debugPrint("DAFTAR BERHASIL");
                      debugPrint("Username: $username");
                      debugPrint("Password: $password");

                      Navigator.pop(context); // kembali ke login
                    }
                  },
                  ValueRadius: 35,
                ),

                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sudah punya akun? "),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Masuk",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

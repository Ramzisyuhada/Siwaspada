import 'package:flutter/material.dart';
import 'package:siwaspada/Page/LoginPage.dart';
import 'package:siwaspada/Service/AuthService.dart';
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
  String email = "";
  String password = "";
  String confirmPassword = "";

  bool isLoading = false;

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

      /// ================= BODY + LOADING =================
      body: Stack(
        children: [
          /// ================= FORM =================
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 39),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  Center(
                    child: Image.asset(
                      "Image/LogoUT.png",
                      width: 120,
                      height: 120,
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text("Lengkapi data diri Anda."),
                  const SizedBox(height: 30),

                  /// USERNAME
                  Costuminputfield(
                    hintText: "Username",
                    iconData: Icons.person,
                    onChanged: (v) => username = v,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Username wajib diisi" : null,
                  ),

                  /// EMAIL
                  Costuminputfield(
                    hintText: "Email",
                    iconData: Icons.email,
                    onChanged: (v) => email = v,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Email wajib diisi";
                      if (!v.contains("@")) return "Email tidak valid";
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
                      if (v == null || v.isEmpty) return "Password wajib diisi";
                      if (v.length < 8) return "Minimal 8 karakter";
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
                    dataColorText: Colors.white,
                    ValueRadius: 35,
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => isLoading = true);

                              try {
                                await AuthService.register(
                                  username: username,
                                  email: email,
                                  password: password,
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Registrasi berhasil"),
                                  ),
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginPage(),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                  ),
                                );
                              } finally {
                                setState(() => isLoading = false);
                              }
                            }
                          },
                  ),

                  const SizedBox(height: 20),

                  /// LINK LOGIN
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Sudah punya akun? "),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
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
                  ),
                  const SizedBox(height: 40),
                ],
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

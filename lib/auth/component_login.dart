import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_grow/components/admin_success_login.dart';
import 'package:smart_grow/components/colors.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cupertino_text_button/cupertino_text_button.dart';
import 'package:smart_grow/components/user_success_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComponentFormLogin extends StatefulWidget {
  const ComponentFormLogin({super.key});

  @override
  State<ComponentFormLogin> createState() => _ComponentFormLoginState();
}

class _ComponentFormLoginState extends State<ComponentFormLogin> {
  String? email;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];
  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  bool isLoading = false;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    final url = Uri.parse(
      'https://backendappsgh-project.up.railway.app/api/auth/login',
    );
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': usernameController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('role', data['role']);
        if (data['role'] == 'admin') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AdminSuccessLogin.routeName,
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            UserSuccessLogin.routeName,
            (route) => false,
          );
        }
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'LOGIN GAGAL',
          desc: data['message'] ?? 'Username atau password salah',
          btnOkText: 'OK',
          btnOkColor: Colors.red,
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'TERJADI KESALAHAN',
        desc: 'Gagal terhubung ke server',
        btnOkText: 'OK',
        btnOkColor: Colors.red,
        btnOkOnPress: () {},
      ).show();
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            autofocus: false,
            showCursor: true,
            cursorColor: Colors.teal,
            textAlign: TextAlign.start,
            controller: usernameController,
            scrollPhysics: const ScrollPhysics(),
            textInputAction: TextInputAction.next,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              alignLabelWithHint: true,
              label: const Text('Nama Lengkap'),
              prefixIcon: const Icon(
                size: 30,
                color: secondaryColor,
                Icons.account_box_rounded,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nama tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            autofocus: false,
            showCursor: true,
            cursorColor: Colors.teal,
            textAlign: TextAlign.start,
            controller: passwordController,
            obscureText: !isPasswordVisible,
            scrollPhysics: const ScrollPhysics(),
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.visiblePassword,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              alignLabelWithHint: true,
              label: const Text('Password'),
              prefixIcon: const Icon(
                size: 30,
                color: secondaryColor,
                Icons.lock_rounded,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password tidak boleh kosong';
              }
              return null;
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: TextButton(
              onPressed: isLoading ? null : loginUser,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Text(
                        "Masuk",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 5.0),
                  child: const Text(
                    "Belum Punya Akun?",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                CupertinoTextButton(
                  text: "Beritahu Admin",
                  softWrap: true,
                  color: Colors.teal,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.scale,
                      title: 'YAHAHAA',
                      desc: 'Yahh Sayangnya Kamu Gak Diajak Awokawok',
                      btnOkText: 'Ya udah deh',
                      btnOkColor: Colors.teal,
                      btnCancelColor: Colors.grey,
                      btnOkOnPress: () {},
                    ).show();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

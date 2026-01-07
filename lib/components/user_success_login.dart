  import 'package:flutter/material.dart';
  import 'package:awesome_dialog/awesome_dialog.dart';
  import 'package:smart_grow/pages/user/user_dashboard.dart';

  class UserSuccessLogin extends StatelessWidget {
    const UserSuccessLogin({super.key});
    static String routeName = "/user-succcess-login";

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: SuccessLoginAdmin(),
        backgroundColor: Colors.transparent,
      );
    }
  }

  class SuccessLoginAdmin extends StatefulWidget {
    const SuccessLoginAdmin({super.key});

    @override
    State<SuccessLoginAdmin> createState() => _SuccessLoginAdminState();
  }

  class _SuccessLoginAdminState extends State<SuccessLoginAdmin> {
    @override
    Widget build(BuildContext context) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          title: 'BERHASIL MASUK AKUN!',
          desc: 'Selamat datang Bro!',
          btnOkText: 'LANJUTKAN',
          btnOkOnPress: () {
            Navigator.pushReplacementNamed(
              context,
              DashboardUserScreen.routeName,
            );
          },
        ).show();
      });

      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/background.png'),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

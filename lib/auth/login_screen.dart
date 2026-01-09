import 'package:flutter/material.dart';
import 'package:smart_grow/components/colors.dart';
import 'package:smart_grow/components/size_config.dart';
import 'package:smart_grow/auth/component_login.dart' show ComponentFormLogin;
import 'package:smart_grow/pages/admin/admin_dashboard.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(primary: true, body: const BodyLogin());
  }
}

class BodyLogin extends StatefulWidget {
  const BodyLogin({super.key});

  @override
  State<BodyLogin> createState() => _BodyLoginState();
}

class _BodyLoginState extends State<BodyLogin> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 10, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                child: Image.asset(
                  'assets/image/Logos-app.png',
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 3, top: 10),
                child: const Text(
                  'Smart Grow',
                  style: TextStyle(
                    fontSize: 18,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 80),
          child: Image.asset(
            'assets/image/Smart_Grow_Logos.png',
            height: 250,
            fit: BoxFit.contain,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: const ComponentFormLogin(),
        ),
        // Container(
        //   margin: const EdgeInsets.only(top: 20),
        //   child: TextButton(onPressed: () {
        //     Navigator.pushNamed(context, DashboardAdminScreen.routeName);
        //   }, child: Text("Admin")),
        // )
      ],
    );
  }
}

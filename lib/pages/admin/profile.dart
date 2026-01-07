import 'package:flutter/material.dart';
import 'package:smart_grow/components/colors.dart';
import 'package:smart_grow/pages/admin/components/component_profile.dart' show ComponentProfileAdmin;

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});
  static String routeName = "/profile-admin";

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BodyProfileAdmin());
  }
}

class BodyProfileAdmin extends StatefulWidget {
  const BodyProfileAdmin({super.key});

  @override
  State<BodyProfileAdmin> createState() => _BodyProfileAdminState();
}

class _BodyProfileAdminState extends State<BodyProfileAdmin> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                child: Image.asset(
                  'assets/image/Logos-app.png',
                  height: 45,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 2, top: 10),
                child: const Text(
                  'Smart Grow',
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const ComponentProfileAdmin(),
      ],
    );
  }
}

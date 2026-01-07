import 'package:flutter/material.dart';
import 'package:smart_grow/components/colors.dart';
import 'package:smart_grow/pages/user/components/component_user_profile.dart'
    show ComponentUserProfile;

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});
  static String routeName = "/profile-akun";

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BodyUserScreen());
  }
}

class BodyUserScreen extends StatefulWidget {
  const BodyUserScreen({super.key});

  @override
  State<BodyUserScreen> createState() => _BodyUserScreenState();
}

class _BodyUserScreenState extends State<BodyUserScreen> {
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
        const ComponentUserProfile(),
      ],
    );
  }
}

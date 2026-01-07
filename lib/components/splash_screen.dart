import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_grow/auth/login_screen.dart';
import 'package:smart_grow/components/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_grow/pages/admin/admin_dashboard.dart';
import 'package:smart_grow/pages/user/user_dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final role = prefs.getString('role');

    if (isLoggedIn && role == 'admin') {
      Navigator.pushReplacementNamed(context, DashboardAdminScreen.routeName);
    } else if (isLoggedIn && role == 'user') {
      Navigator.pushReplacementNamed(context, DashboardUserScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/Smart_Grow_Logos.png',
              height: 300,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}

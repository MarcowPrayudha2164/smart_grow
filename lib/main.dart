import 'package:flutter/material.dart';
import 'package:smart_grow/components/colors.dart';
import 'package:smart_grow/components/routes.dart';
import 'package:smart_grow/components/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Lexend',
        scaffoldBackgroundColor: primaryColor,
      ),
      routes: appRoutes,
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
    );
  }
}

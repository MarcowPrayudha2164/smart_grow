import 'package:flutter/material.dart';
import 'package:smart_grow/auth/login_screen.dart';
import 'package:smart_grow/components/admin_success_login.dart';
import 'package:smart_grow/components/splash_screen.dart';
import 'package:smart_grow/components/user_success_login.dart';
import 'package:smart_grow/pages/admin/admin_dashboard.dart';
import 'package:smart_grow/pages/admin/history.dart';
import 'package:smart_grow/pages/admin/kontrol_alat.dart';
import 'package:smart_grow/pages/admin/monitoring_sensor.dart';
import 'package:smart_grow/pages/admin/profile.dart';
import 'package:smart_grow/pages/user/monitoring_sensor.dart';
import 'package:smart_grow/pages/user/profile.dart';
import 'package:smart_grow/pages/user/user_dashboard.dart';

final Map<String, WidgetBuilder> appRoutes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  AdminSuccessLogin.routeName: (context) => const AdminSuccessLogin(),
  UserSuccessLogin.routeName: (context) => const UserSuccessLogin(),
  DashboardAdminScreen.routeName: (context) => const DashboardAdminScreen(),
  AdminMonitoringScreen.routeName: (context) => const AdminMonitoringScreen(),
  KontrolAlatScreen.routeName: (context) => const KontrolAlatScreen(),
  AdminHistoryScreen.routeName: (context) => const AdminHistoryScreen(),
  AdminProfileScreen.routeName: (context) => const AdminProfileScreen(),
  DashboardUserScreen.routeName: (context) => const DashboardUserScreen(),
  UserMonitoringScreen.routeName: (context) => const UserMonitoringScreen(),
  UserProfileScreen.routeName: (context) => const UserProfileScreen(),
};

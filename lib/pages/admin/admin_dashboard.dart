import 'package:flutter/material.dart';
import 'package:smart_grow/components/colors.dart';
import 'package:smart_grow/pages/admin/history.dart' show AdminHistoryScreen;
import 'package:smart_grow/pages/admin/kontrol_alat.dart' show KontrolAlatScreen;
import 'package:smart_grow/pages/admin/monitoring_sensor.dart' show AdminMonitoringScreen;
import 'package:smart_grow/pages/admin/profile.dart' show AdminProfileScreen;

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});
  static String routeName = '/dashboard-admin';

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    AdminMonitoringScreen(),
    KontrolAlatScreen(),
    AdminHistoryScreen(),
    AdminProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.dashboard_rounded, 'Data', 0),
          _navItem(Icons.broadcast_on_home_rounded, 'Kontrol', 1),
          _navItem(Icons.assignment_rounded, 'History', 2),
          _navItem(Icons.assignment_ind, 'Akun', 3)
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() => _currentIndex = index);
      },
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? greenColor : Colors.white,
            size: 25,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? greenColor : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

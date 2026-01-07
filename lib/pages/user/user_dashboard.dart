import 'package:flutter/material.dart';
import 'package:smart_grow/components/colors.dart';
import 'package:smart_grow/pages/user/history.dart' show UserHistoryScreen;
import 'package:smart_grow/pages/user/monitoring_sensor.dart'
    show UserMonitoringScreen;
import 'package:smart_grow/pages/user/profile.dart' show UserProfileScreen;

class DashboardUserScreen extends StatefulWidget {
  const DashboardUserScreen({super.key});
  static String routeName = '/dashboard-user';

  @override
  State<DashboardUserScreen> createState() => _DashboardUserScreenState();
}

class _DashboardUserScreenState extends State<DashboardUserScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    UserMonitoringScreen(),
    UserHistoryScreen(),
    UserProfileScreen(),
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
          _navItem(Icons.assignment_rounded, 'History', 1),
          _navItem(Icons.assignment_ind, 'Akun', 2),
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
          Icon(icon, color: isActive ? greenColor : Colors.white, size: 25),
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

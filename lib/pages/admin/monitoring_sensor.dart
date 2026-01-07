import 'package:flutter/material.dart';
import 'package:smart_grow/components/colors.dart';
import 'package:smart_grow/widgets/monitoring_data.dart'
    show WidgetMonitoringData;

class AdminMonitoringScreen extends StatelessWidget {
  const AdminMonitoringScreen({super.key});
  static String routeName = '/monitoring-data';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const BodyMonitoringAdmin());
  }
}

class BodyMonitoringAdmin extends StatefulWidget {
  const BodyMonitoringAdmin({super.key});

  @override
  State<BodyMonitoringAdmin> createState() => _BodyMonitoringAdminState();
}

class _BodyMonitoringAdminState extends State<BodyMonitoringAdmin> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 10, left: 10),
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
        Container(
          margin: const EdgeInsets.only(left: 15, top: 5),
          child: const Text(
            "Halo Admin, Selamat Datang 👋",
            style: TextStyle(
              fontSize: 13,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15, top: 30, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                child: Icon(Icons.dashboard_rounded, size: 30, color: secondaryColor),
              ),
              Container(
                margin: const EdgeInsets.only(left: 1, top: 3),
                child: const Text(
                  "Monitoring Sensor Data",
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
        const WidgetMonitoringData(),
      ],
    );
  }
}

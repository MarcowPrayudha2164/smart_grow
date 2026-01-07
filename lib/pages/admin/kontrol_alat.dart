import 'package:flutter/material.dart';
import 'package:smart_grow/components/colors.dart';
import 'package:smart_grow/widgets/kontrol_alat_sensor.dart';


class KontrolAlatScreen extends StatelessWidget {
  const KontrolAlatScreen({super.key});
  static String routeName = '/kontrol-alat';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const BodyKontrolAlat());
  }
}

class BodyKontrolAlat extends StatefulWidget {
  const BodyKontrolAlat({super.key});

  @override
  State<BodyKontrolAlat> createState() => _BodyKontrolAlatState();
}

class _BodyKontrolAlatState extends State<BodyKontrolAlat> {
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
          margin: const EdgeInsets.only(left: 15, top: 30, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.on_device_training_rounded,
                  size: 30,
                  color: secondaryColor,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 1, top: 3),
                child: const Text(
                  "Hidupkan dan Matikan Alat",
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
        const PumpControlPage(),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smart_grow/components/colors.dart';

class Data extends StatefulWidget {
  const Data({super.key});

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _textValue("Suhu", Icons.thermostat_rounded, "32°C"),
          const SizedBox(height: 10),
          _textValue("Kelembapan", Icons.water_outlined, "75%"),
          const SizedBox(height: 10),
          _textValue("PH Air", Icons.water_drop_outlined, "6.2 pH"),
          const SizedBox(height: 10),
          _textValue("Level Air", Icons.leaderboard_rounded, "65%"),
          const SizedBox(height: 10),
          _textValue("Kualitas Air", Icons.water_drop_rounded, "60ppm"),
        ],
      ),
    );
  }

  Widget _textValue(String label, IconData icon, String value) {
    return Container(
      margin: const EdgeInsets.only(right: 15, left: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 5, right: 10),
            decoration: BoxDecoration(
              color: primaryColor,
              border: Border.all(color: greenColor, width: 3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: secondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 5, top: 4),
            child: Icon(icon, color: greenColor, size: 35),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 30,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

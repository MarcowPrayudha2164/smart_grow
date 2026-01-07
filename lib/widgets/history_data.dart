import 'package:flutter/material.dart';
import 'package:smart_grow/components/colors.dart';

class WidgetHistoryData extends StatefulWidget {
  const WidgetHistoryData({super.key});

  @override
  State<WidgetHistoryData> createState() => _WidgetHistoryDataState();
}

class _WidgetHistoryDataState extends State<WidgetHistoryData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tableData(
            "Senin",
            "12 Desember 2025",
            "Suhu: 32°C",
            "Kelembapan: 75%",
            "PH Air: 6.2",
            "Level Air: 65%",
          ),
          const SizedBox(height: 10),
          _tableData(
            "Senin",
            "12 Desember 2025",
            "Suhu: 32°C",
            "Kelembapan: 75%",
            "PH Air: 6.2",
            "Level Air: 65%",
          ),
          const SizedBox(height: 10),
          _tableData(
            "Senin",
            "12 Desember 2025",
            "Suhu: 32°C",
            "Kelembapan: 75%",
            "PH Air: 6.2",
            "Level Air: 65%",
          ),
          const SizedBox(height: 10),
          _tableData(
            "Senin",
            "12 Desember 2025",
            "Suhu: 32°C",
            "Kelembapan: 75%",
            "PH Air: 6.2",
            "Level Air: 65%",
          ),
          const SizedBox(height: 10),
          _tableData(
            "Senin",
            "12 Desember 2025",
            "Suhu: 32°C",
            "Kelembapan: 75%",
            "PH Air: 6.2",
            "Level Air: 65%",
          ),
          const SizedBox(height: 10),
          _tableData(
            "Senin",
            "12 Desember 2025",
            "Suhu: 32°C",
            "Kelembapan: 75%",
            "PH Air: 6.2",
            "Level Air: 65%",
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _tableData(
    String hari,
    String tanggal,
    String suhu,
    String kelembapan,
    String ph,
    String level,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 64, 109, 54),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Data (Hari)
          Container(
            margin: const EdgeInsets.only(bottom: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.event_note_rounded,
                    size: 25,
                    color: primaryColor,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5, top: 1),
                  child: Text(
                    hari,
                    style: const TextStyle(
                      fontSize: 15,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Data (Tanggal)
          Container(
            margin: const EdgeInsets.only(bottom: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.date_range_rounded,
                    size: 25,
                    color: primaryColor,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5, top: 3),
                  child: Text(
                    tanggal,
                    style: const TextStyle(
                      fontSize: 15,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Garis Horizontal Start
          Container(
            height: 2,
            margin: const EdgeInsets.only(left: 3, right: 3, top: 3, bottom: 5),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Garis Horizontal End
          // Data (Suhu)
          Container(
            margin: const EdgeInsets.only(bottom: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.thermostat_rounded,
                    size: 25,
                    color: primaryColor,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5, top: 3),
                  child: Text(
                    suhu,
                    style: const TextStyle(
                      fontSize: 15,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Data (Kelembapan)
          Container(
            margin: const EdgeInsets.only(bottom: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.water_outlined,
                    size: 25,
                    color: primaryColor,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5, top: 3),
                  child: Text(
                    kelembapan,
                    style: const TextStyle(
                      fontSize: 15,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Data (PH Air)
          Container(
            margin: const EdgeInsets.only(bottom: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.water_drop_outlined,
                    size: 25,
                    color: primaryColor,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5, top: 3),
                  child: Text(
                    ph,
                    style: const TextStyle(
                      fontSize: 15,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Data (Level Air)
          Container(
            margin: const EdgeInsets.only(bottom: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.leaderboard_rounded,
                    size: 25,
                    color: primaryColor,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5, top: 3),
                  child: Text(
                    level,
                    style: const TextStyle(
                      fontSize: 15,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

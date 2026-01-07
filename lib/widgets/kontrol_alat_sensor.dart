import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_grow/components/colors.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class PumpControlPage extends StatefulWidget {
  const PumpControlPage({super.key});

  @override
  State<PumpControlPage> createState() => _PumpControlPageState();
}

class _PumpControlPageState extends State<PumpControlPage> {
  bool pump1 = false;
  bool pump2 = false;

  final String apiUrl = "http://192.168.18.6:3000/api/pump";

  Future<void> controlPump(int pump, bool status) async {
    try {
      await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "device": "smartgrow-01",
          "pump": 2,
          "status": status ? "ON" : "OFF",
        }),
      );
    } catch (e) {
      debugPrint("Failed send data: $e");
    }
  }

  void showPumpNotification(String pumpName, bool status) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: status ? 'Berhasil Dinyalakan!' : 'Berhasil Dimatikan!',
      desc: status
          ? '$pumpName berhasil dinyalakan'
          : '$pumpName berhasil dimatikan',
      btnOkText: 'OKE',
      btnOkColor: status ? Colors.teal : Colors.redAccent,
      btnOkOnPress: () {},
    ).show();
  }

  Widget pumpTile(String title, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(color: secondaryColor, width: 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.radar_outlined,
                    color: greenColor,
                    size: 30,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 3),
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: greenColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          pumpTile("POMPA AIR 1", pump1, (val) {
            setState(() => pump1 = val);
            controlPump(1, val);
            showPumpNotification("Pompa Air 1", val);
          }),
          pumpTile("POMPA AIR 2", pump2, (val) {
            setState(() => pump2 = val);
            controlPump(2, val);
            showPumpNotification("Pompa Air 2", val);
          }),
        ],
      ),
    );
  }
}

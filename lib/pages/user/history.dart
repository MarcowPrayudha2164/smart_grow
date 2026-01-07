import 'package:flutter/material.dart';
import 'package:smart_grow/components/colors.dart';
import 'package:smart_grow/widgets/history_data.dart' show WidgetHistoryData;

class UserHistoryScreen extends StatelessWidget {
  const UserHistoryScreen({super.key});
  static String routeName = '/history-data';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const BodyHistoryUser());
  }
}

class BodyHistoryUser extends StatefulWidget {
  const BodyHistoryUser({super.key});

  @override
  State<BodyHistoryUser> createState() => _BodyHistoryUserState();
}

class _BodyHistoryUserState extends State<BodyHistoryUser> {
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
            "Halo KONTOL, Selamat Datang 👋",
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
                child: Icon(
                  Icons.description_rounded,
                  size: 30,
                  color: secondaryColor,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 1, top: 3),
                child: const Text(
                  "History Data Terakhir",
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
        const SizedBox(height: 10),
        const WidgetHistoryData(),
      ],
    );
  }
}

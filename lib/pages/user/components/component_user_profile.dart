import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:smart_grow/auth/login_screen.dart';
import 'package:smart_grow/components/colors.dart';

class ComponentUserProfile extends StatefulWidget {
  const ComponentUserProfile({super.key});

  @override
  State<ComponentUserProfile> createState() => _ComponentUserProfileState();
}

class _ComponentUserProfileState extends State<ComponentUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 15),
                  child: Icon(
                    Icons.face_2_rounded,
                    size: 100,
                    color: greenColor,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 20),
                  child: Text(
                    "JinX Pravolensky",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontSize: 18,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 3, bottom: 15),
                  child: Text(
                    "22421099",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 10, top: 25),
            child: const Text(
              "Pilihan Menu",
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _listMenu(
            Icons.settings_applications_outlined,
            "Sedang Dikembangkan",
            () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.scale,
                title: 'Sedang Dikembangkan',
                desc: 'Sabar Yaa Fitur Ini Sedang Dikembangkan',
                btnOkText: 'Ya udah deh',
                btnOkColor: Colors.teal,
                btnOkOnPress: () {},
              ).show();
            },
          ),
          _listMenu(
            Icons.settings_applications_outlined,
            "Sedang Dikembangkan",
            () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.scale,
                title: 'Sedang Dikembangkan',
                desc: 'Sabar Yaa Fitur Ini Sedang Dikembangkan',
                btnOkText: 'Ya udah deh',
                btnOkColor: Colors.teal,
                btnOkOnPress: () {},
              ).show();
            },
          ),
          _listMenu(Icons.exit_to_app_rounded, "Keluar Akun", () {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              animType: AnimType.scale,
              title: 'LogOut?',
              desc: 'Yakin Ingin Keluar Akun?',
              btnOkText: 'Ya Tentu',
              btnCancelText: 'Tidak Jadi',
              btnOkColor: Colors.teal,
              btnCancelColor: Colors.red,
              btnOkOnPress: () {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
              btnCancelOnPress: () {},
            ).show();
          }),
        ],
      ),
    );
  }

  Widget _listMenu(IconData icon, String label, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
        color: greenColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10, top: 6),
            child: Icon(icon, size: 35, color: primaryColor),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(
              label,
              style: TextStyle(
                color: primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

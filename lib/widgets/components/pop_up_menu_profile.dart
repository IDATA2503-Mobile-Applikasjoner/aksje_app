import 'package:flutter/material.dart';
import 'package:aksje_app/providers/token_manager.dart';
import 'package:aksje_app/widgets/screens/log-in.dart';

Widget buildPopUpMenuProfile(BuildContext context) {
  return PopupMenuButton(
    icon: const Icon(Icons.person, color: Colors.black),
    itemBuilder: (BuildContext context) {
      return [
        const PopupMenuItem(
          value: 'logout',
          child: Text("Log out"),
        ),
      ];
    },
    onSelected: (value) {
      logOut(context);
    },
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: const BorderSide(color: Color.fromARGB(255, 0, 89, 255)),
    ),
  );
}

  void logOut(BuildContext context) async {
    TokenManager.removeToken();
    String? toke = await TokenManager.getToken();
    if(toke == null) {
      navToLoginPage(context);
    }
  }

    void navToLoginPage(BuildContext context) {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
      builder: (context) => const LoginPage(),
      )
    );
  }
import 'package:flutter/material.dart';
import 'package:aksje_app/providers/token_manager.dart';
import 'package:aksje_app/widgets/screens/log_in.dart';

/// Builds a popup menu for profile actions, including logout.
///
/// [context] is the BuildContext in which the popup menu will be displayed.
Widget buildPopUpMenuProfile(BuildContext context) {
  return PopupMenuButton(
    icon: const Icon(Icons.person),
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
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}

/// Handles the logout functionality.
///
/// Removes the JWT token and navigates to the login page if successful.
/// [context] is the BuildContext used for navigation.
void logOut(BuildContext context) async {
  TokenManager.removeToken();
  String? token = await TokenManager.getToken();
  if (token == null) {
    navToLoginPage(context);
  }
}

/// Navigates to the login page.
///
/// Replaces the current page in the navigation stack with [LoginPage].
/// [context] is the BuildContext used for navigation.
void navToLoginPage(BuildContext context) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ));
}

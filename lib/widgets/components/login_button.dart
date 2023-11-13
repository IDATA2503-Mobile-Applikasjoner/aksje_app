import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/screens/main_page.dart';

/// Builds a login button with a loading indicator.
///
/// Displays a circular progress indicator when [isLoading] is true, otherwise
/// displays an elevated button for login.
/// [emailController] and [passwordController] are used to retrieve user input.
/// [login] is the function to be executed when the button is pressed.
/// [context] is the BuildContext for navigation or UI updates.
Widget buildLoginButton(
    bool isLoading,
    TextEditingController emailController,
    TextEditingController passwordController,
    Function login,
    BuildContext context) {
  if (isLoading) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  } else {
    return ElevatedButton(
      onPressed: () {
        String email = emailController.text;
        String password = passwordController.text;
        print('Login button pressed');

        login(email, password, context);
      },
      child: const Text('Login'),
    );
  }
}

/// Navigates to the MainPage.
///
/// Replaces the current page in the navigation stack with [MainPage].
/// [context] is the BuildContext used for navigation.
void navMainPage(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const MainPage(selectedIndex: 0)),
  );
}

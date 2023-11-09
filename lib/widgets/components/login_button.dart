import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/screens/main_page.dart';

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

void navInventory(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => MainPage()),
    );
}
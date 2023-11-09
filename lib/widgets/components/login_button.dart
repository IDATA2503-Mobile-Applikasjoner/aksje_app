import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/screens/inventory.dart';

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
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Inventory()),
  );
}
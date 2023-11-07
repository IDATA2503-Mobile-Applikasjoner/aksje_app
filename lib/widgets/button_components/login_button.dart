import 'package:flutter/material.dart';

Widget buildLoginButton(
  bool isLoading, TextEditingController emailController, TextEditingController passwordController, Function login) {
  if (isLoading) {
    return Center(
      child: CircularProgressIndicator(),
    );
  } else {
    return ElevatedButton(
      onPressed: () {
        String email = emailController.text;
        String password = passwordController.text;
        print('Login button pressed');

        // Add a 1-second delay here to simulate loading
        Future.delayed(Duration(seconds: 3), () {
          login(email, password);
        });
      },
      child: const Text('Login'),
    );
  }
}
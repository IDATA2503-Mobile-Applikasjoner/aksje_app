import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);


  void createUser(String email, String password) {
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text('Email'),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                Text('Passowrd'),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'password'
                  ),
                ),
                Text('Confirm Passowrd'),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'confirm password'
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
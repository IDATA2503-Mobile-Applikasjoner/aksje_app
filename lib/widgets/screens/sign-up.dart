import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool checkPassowrd(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  Future<void> createUser(BuildContext context, String email, String password) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/user');
    var body = jsonEncode({'email': email, 'password': password});

    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );
        if (response.statusCode == 201) {
          print('User created successfully');
        } 
        else if (response.statusCode == 400) {
          var errorMessage = json.decode(response.body);
          print('Error message: $errorMessage');
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
      );
    }
    } catch (e) {
      print('Failed to create user. Error: $e');
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(100),
            child: Column(
              children: [
                const Text('Sign Up'),
                const Text('Email'),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const Text('Password'),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                const Text('Confirm Password'),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    String email = emailController.text;
                    String password = passwordController.text;
                    String confirmPassword = confirmPasswordController.text;
                    if(checkPassowrd(password, confirmPassword)) {
                      createUser(context, email, password);
                    }
                    else {
                      print("Not same password");
                    }
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  _SingUpSate createState() => _SingUpSate();

}

  class _SingUpSate extends State<SignUp> {
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
            var errorMessage = response.body;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
              ),
            );
          }
      } catch (e) {
        //print('Failed to create user. Error: $e');
      }
    }
    
    void cancel() {
      Navigator.pop(
        context
      );
    }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email"
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password"
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirm Password"
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String email = emailController.text;
                String password = passwordController.text;
                String confirmPassword = confirmPasswordController.text;
                if(checkPassowrd(password, confirmPassword)) {
                  createUser(context, email, password);
                  }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("The passwords didn't match"),
                    ),
                  );
                }
              },
              child: const Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () {
                cancel();
              },
              child: const Text("Cancel"),
            )
          ],
        ),
      ),
    );
  }
  }
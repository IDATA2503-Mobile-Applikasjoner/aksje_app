import 'package:aksje_app/widgets/screens/log_in.dart';
import 'package:aksje_app/widgets/screens/new_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aksje_app/widgets/components/flush_bar.dart';
import '../../globals.dart' as globals;

/// SignUp is a StatefulWidget that facilitates user registration in the application.
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Text editing controllers for email, password, and confirm password fields.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  /// Checks if the password and confirm password match.
  bool checkPassword(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  /// Creates a new user account with the provided email and password.
  Future<void> createUser(
      BuildContext context, String email, String password) async {
    var url = Uri.parse('${globals.baseUrl}/api/user');
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
        navToLoginSuccessScreen();
      } else if (response.statusCode == 400) {
        var errorMessage = response.body;
        buildFlushBar(
            context,
            errorMessage,
            "Error",
            const Color.fromARGB(255, 175, 25, 25),
            const Color.fromARGB(255, 233, 0, 0));
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Navigates to the NewUserPage on successful sign up.
  void navToLoginSuccessScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const NewUserPage()));
  }

  /// Navigates back to the login page.
  void cancel() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
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
              decoration: const InputDecoration(labelText: "Email"),
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Confirm Password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String email = emailController.text;
                String password = passwordController.text;
                String confirmPassword = confirmPasswordController.text;
                if (checkPassword(password, confirmPassword)) {
                  createUser(context, email, password);
                } else {
                  buildFlushBar(
                      context,
                      "The passwords didn't match",
                      "Error",
                      const Color.fromARGB(255, 175, 25, 25),
                      const Color.fromARGB(255, 233, 0, 0));
                }
              },
              child: const Text('Sign Up'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 100, 100, 100),
              ),
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

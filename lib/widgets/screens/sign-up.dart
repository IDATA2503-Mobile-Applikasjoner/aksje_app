import 'package:aksje_app/widgets/screens/log-in.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aksje_app/widgets/screens/sign_up_success.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:aksje_app/widgets/components/flush_bar_error.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SingUpSate createState() => _SingUpSate();

}

  class _SingUpSate extends State<SignUp> {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    //Checks if the password and confirmPassword maches.
    bool checkPassowrd(String password, String confirmPassword) {
      return password == confirmPassword;
    }

    //Creates a new user
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
            navToLoginSuccessScreen();
          } 
          else if (response.statusCode == 400) {
            var errorMessage = response.body;
            buildFlushBarError(context, errorMessage);
          }
      } catch (e) {
        return Future.error(e);
      }
    }

    //Navigates to success spage
    void navToLoginSuccessScreen() {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => const SignUpSuccessPage()
        )
      );
    }
    
    //Returns to login page
    void cancel() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage())
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
                  buildFlushBarError(context, "The passwords didn't match");
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
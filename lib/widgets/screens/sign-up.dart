import 'package:aksje_app/widgets/screens/log-in.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aksje_app/widgets/screens/sign_up_success.dart';
import 'package:another_flushbar/flushbar.dart';

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
            navToLoginSuccessScreen();
          } 
          else if (response.statusCode == 400) {
            var errorMessage = response.body;
            showFloatingFlushbar(context, errorMessage);
          }
      } catch (e) {
        print('Failed to create user. Error: $e');
      }
    }

    void navToLoginSuccessScreen() {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => const SignUpSuccessPage()
        )
      );
    }
    
    void cancel() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage())
      );
    }

    void showFloatingFlushbar(BuildContext context, String errorMessage) {
      Flushbar(
        padding: const EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(8),
        backgroundGradient: const LinearGradient(
          colors: [Color.fromARGB(255, 175, 25, 25), Color.fromARGB(255, 233, 0, 0)],
          stops: [0.6, 1],
        ),
        boxShadows: const [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(3, 3),
            blurRadius: 3,
          ),
        ],
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
        title: 'Error',
        message: errorMessage,
        margin: const EdgeInsets.only(top: 100, left: 20, right: 20),
        flushbarPosition: FlushbarPosition.TOP, 
        duration: const Duration(seconds: 3),
      ).show(context);
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
                  showFloatingFlushbar(context, "The passwords didn't match");
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
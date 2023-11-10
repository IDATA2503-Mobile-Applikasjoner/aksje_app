import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/screens/log-in.dart';

class SignUpSuccessPage extends StatelessWidget {
  const SignUpSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.task_alt,
              color: Colors.green,
              size: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              "Success!",
              style: TextStyle(
                fontSize: 30
              ),
            ),
            const SizedBox(height: 10),
            const Text("You can now log in"),
            const SizedBox(height: 150),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => const LoginPage()
                  ),
                );
              },
              child: const Text('Go To Login'),
            ),
          ],
        ),
      ),
    );
  }
}
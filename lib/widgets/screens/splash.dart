import 'package:flutter/material.dart';
import 'dart:async';
import 'package:aksje_app/widgets/screens/log_in.dart';

/// Represents the startup screen for the app.
/// This screen displays an image for 3 seconds before navigating to the Login Page.
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // Initiates the timer for the splash screen duration.
    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage())));
  }

  @override
  Widget build(BuildContext context) {
    // Defines the image to be displayed on the splash screen.
    var image = Image.asset('lib/images/InvestmentBro.png', height: 300);

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Center(
            child: image, // Displays the image at the center of the screen.
          ),
        ),
      ),
    );
  }
}

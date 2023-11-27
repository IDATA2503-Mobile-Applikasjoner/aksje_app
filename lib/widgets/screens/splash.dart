import 'package:flutter/material.dart';
import 'dart:async';
import 'package:aksje_app/widgets/screens/log_in.dart';

// Splash class represents the splash screen of the app.
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  // Declaration of the animation controller and the animation object.
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initializing the animation controller with a duration of 3 seconds.
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true); // Making the animation repeat in reverse.

    // Defining the animation with a range from 0.5 to 1.0.
    _animation = Tween(begin: 0.5, end: 1.0).animate(_controller);

    // Timer to navigate to the Login Page after 3 seconds.
    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage())));
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Disposing the animation controller on widget dispose.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Defining the image to be displayed on the splash screen.
    var image = Image.asset('lib/images/Investmate.png', height: 300);

    // The main build method for the splash screen.
    return MaterialApp(
      home: Scaffold(
        body: Container(
          // Decoration for the container with a linear gradient background.
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE0E0E0), // Light grey color
                Color(0xFFF5F5F5), // Even lighter grey color
              ],
            ),
          ),
          // Centering the fade transition widget which contains the image.
          child: Center(
            child: FadeTransition(
              opacity: _animation, // Applying the fade animation to the image.
              child: image, // The image widget defined earlier.
            ),
          ),
        ),
      ),
    );
  }
}

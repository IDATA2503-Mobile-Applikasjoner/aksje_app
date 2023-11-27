import 'package:flutter/material.dart';
import 'dart:async';
import 'package:aksje_app/widgets/screens/log_in.dart';

//Repsresent the start up screen for the app
//Screen shows for 3 secunds before going to Login Page.
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage())));
    var image = Image.asset('lib/images/InvestmentBro.png', height: 300);
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Center(
            child: image,
          ),
        ),
      ),
    );
  }
}

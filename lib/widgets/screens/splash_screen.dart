import 'package:flutter/material.dart';
import 'dart:async';
import 'package:aksje_app/widgets/screens/log-in.dart';

class Splash extends StatefulWidget {
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
      Duration(seconds: 5),
        () =>
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage()
          )
        )
      );
    var image = Image.asset('lib/images/InvestmentBro.png', height: 300);
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: new BoxDecoration(color: Colors.white),
          child: new Center(
            child: image,
          ),
        ), 
      ),
    );
  }
}
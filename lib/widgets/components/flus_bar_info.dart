  import 'package:flutter/material.dart';
  import 'package:another_flushbar/flushbar.dart';


  void buildFlushBarInfo(BuildContext context, String infoMassage) {
    Flushbar(
      padding: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(8),
      backgroundGradient: const LinearGradient(
        colors: [
          Color.fromARGB(255, 38, 104, 35),
          Color.fromARGB(255, 45, 143, 0)
        ],
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
      title: 'Info',
      message: infoMassage,
      margin: const EdgeInsets.only(top: 100, left: 20, right: 20),
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 6),
    ).show(context);
  }
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

//Error masage afther user trying to do an action it can not do.
void buildFlushBarError(BuildContext context, String errorMassage) {
  Flushbar(
    padding: const EdgeInsets.all(10),
    borderRadius: BorderRadius.circular(8),
    backgroundGradient: const LinearGradient(
      colors: [
        Color.fromARGB(255, 175, 25, 25),
        Color.fromARGB(255, 233, 0, 0)
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
    title: 'Error',
    message: errorMassage,
    margin: const EdgeInsets.only(top: 100, left: 20, right: 20),
    flushbarPosition: FlushbarPosition.TOP,
    duration: const Duration(seconds: 6),
  ).show(context);
}
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

/// Builds and displays an informational message using Flushbar.
///
/// This function is used to provide feedback after an action is performed.
/// [context] is the BuildContext in which the Flushbar will be shown.
/// [infoMessage] is the text content of the information message.
void buildFlushBar(BuildContext context, String infoMessage, String title, Color color1, Color color2) {
  Flushbar(
    padding: const EdgeInsets.all(10),
    borderRadius: BorderRadius.circular(8),
    backgroundGradient: LinearGradient(
      colors: [color1, color2],
      stops: const [0.6, 1],
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
    title: title,
    message: infoMessage,
    margin: const EdgeInsets.only(top: 100, left: 20, right: 20),
    flushbarPosition: FlushbarPosition.TOP,
    duration: const Duration(seconds: 6),
  ).show(context);
}

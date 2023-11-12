import 'package:flutter/material.dart';
import 'package:aksje_app/models/user.dart';

//Class that handels the session uuser.
//With this class you can get the logd in user in all pages.
class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }
}
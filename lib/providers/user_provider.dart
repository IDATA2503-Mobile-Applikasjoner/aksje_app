import 'package:flutter/material.dart';
import 'package:aksje_app/models/user.dart';

/// Manages the session user for the application.
///
/// It enables access to the currently logged-in user across different pages.
class UserProvider extends ChangeNotifier {
  /// The currently logged-in user.
  User? _user;

  /// Retrieves the current user.
  ///
  /// Returns the current user if one is set, otherwise null.
  User? get user => _user;

  /// Sets the user for the current session.
  ///
  /// Calling this function with a new user will update the session and notify listeners.
  /// [newUser] is the user to be set as the current user.
  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }
}

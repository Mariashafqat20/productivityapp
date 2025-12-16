import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _name = "Baseer";
  String _email = "baseer.dev@example.com";
  String? _profilePicPath;

  String get name => _name;
  String get email => _email;
  String? get profilePicPath => _profilePicPath;

  void updateProfile({String? name, String? email, String? profilePicPath}) {
    if (name != null) _name = name;
    if (email != null) _email = email;
    if (profilePicPath != null) _profilePicPath = profilePicPath;
    notifyListeners();
  }
}

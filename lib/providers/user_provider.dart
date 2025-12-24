import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  String _name = "Guest";
  String _email = "";
  String? _profilePicPath;
  bool _isLoading = false;

  User? get user => _user;
  String get name => _name;
  String get email => _email;
  String? get profilePicPath => _profilePicPath;
  bool get isLoading => _isLoading;

  UserProvider() {
    _init();
  }

  void _init() async {
    // 1. Load the saved image path from phone storage
    final prefs = await SharedPreferences.getInstance();
    _profilePicPath = prefs.getString('profile_pic_path');

    // 2. Listen to User Login State
    _authService.user.listen((User? user) {
      _user = user;
      if (user != null) {
        _email = user.email ?? "";
        _name = user.displayName ?? "User";
      } else {
        _email = "";
        _name = "Guest";
      }
      notifyListeners();
    });
  }

  Future<void> updateProfile({String? name, String? email, String? profilePicPath}) async {
    if (name != null) {
      _name = name;
      await _user?.updateDisplayName(name);
    }

    // 3. Save the new image path to phone storage
    if (profilePicPath != null) {
      _profilePicPath = profilePicPath;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_pic_path', profilePicPath);
    }

    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _authService.signIn(email: email, password: password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password, String name) async {
    try {
      _isLoading = true;
      notifyListeners();
      UserCredential? cred = await _authService.signUp(email: email, password: password, name: '');
      if (cred != null && cred.user != null) {
        await cred.user!.updateDisplayName(name);
        _name = name;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    // Optional: Clear profile pic on logout
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('profile_pic_path');
    // _profilePicPath = null;
    // notifyListeners();
  }
}
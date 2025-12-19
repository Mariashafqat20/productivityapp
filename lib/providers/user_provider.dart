import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  void _init() {
    _authService.user.listen((User? user) {
      _user = user;
      if (user != null) {
        _email = user.email ?? "";
        _name = user.displayName ?? "User"; // Basic default, can be enhanced
      } else {
         _email = "";
         _name = "Guest";
      }
      notifyListeners();
    });
  }


  void updateProfile({String? name, String? email, String? profilePicPath}) async {
    // Note: Updating email/password in Firebase requires re-authentication usually.
    // This local update is fine for UI but for backend consistency we might need more logic
    // or use updateDisplayName etc from Firebase User.
    if (name != null) {
        _name = name;
        await _user?.updateDisplayName(name);
    } 
    // if (email != null) _email = email; // Changing email is sensitive
    if (profilePicPath != null) _profilePicPath = profilePicPath; // Local only for now unless stored in Firestore/Storage
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
      UserCredential? cred = await _authService.signUp(email: email, password: password);
      if (cred != null && cred.user != null) {
        await cred.user!.updateDisplayName(name);
        _name = name; // Update local state immediately
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
     await _authService.signOut();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Initialize Firestore

  // Auth User Stream
  Stream<User?> get user => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // --- GOOGLE SIGN IN (Updated) ---
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled the sign-in

      // 2. Obtain the auth details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // 5. SAVE TO FIRESTORE
      // We check if the user exists first so we don't overwrite existing data (like custom fields)
      if (userCredential.user != null) {
        await _saveUserToFirestore(
          user: userCredential.user!,
          name: googleUser.displayName ?? 'No Name',
          email: googleUser.email,
        );
      }

      return userCredential;
    } catch (e) {
      if (kDebugMode) print('Error (Google SignIn): $e');
      rethrow;
    }
  }

  // --- SIGN UP WITH EMAIL (Updated) ---
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Create User
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      // SAVE TO FIRESTORE
      if (userCredential.user != null) {
        await _saveUserToFirestore(
            user: userCredential.user!,
            name: name,
            email: email
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print('FirebaseAuthException: ${e.code}');
      rethrow;
    }
  }

  // --- HELPER: Save User Data ---
  Future<void> _saveUserToFirestore({required User user, required String name, required String email}) async {
    try {
      // Use 'set' with Merge: true.
      // This creates the document if it doesn't exist, or updates it if it does.
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        // Add default role or profile pic here if needed
      }, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) print('Error saving to Firestore: $e');
    }
  }

  // --- EXISTING METHODS ---

  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
      // Note: We usually don't need to save data on simple login,
      // but you could update 'lastLogin' here if you wanted.
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print('FirebaseAuthException: ${e.code}');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }


  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
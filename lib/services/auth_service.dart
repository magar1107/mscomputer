// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Admin login with email/password
  Future<UserCredential?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Check if current user is admin
  bool isAdmin() {
    User? user = _auth.currentUser;
    if (user != null) {
      List<String> adminEmails = [
        'admin@mscomputersangola.com',
        'your-email@example.com'  // Add your email here
      ];
      return adminEmails.contains(user.email);
    }
    return false;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Get current user email
  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  // Stream for auth state changes
  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }
}

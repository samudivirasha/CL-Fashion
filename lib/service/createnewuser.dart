import 'package:firebase_auth/firebase_auth.dart';

class AdminAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new user without affecting the current admin session
  Future<UserCredential?> createUserAsAdmin(
      String email, String password) async {
    try {
      // Save current admin user
      User? currentAdmin = _auth.currentUser;
      if (currentAdmin == null) {
        throw Exception('No admin is currently logged in');
      }

      // Get admin token for re-authentication later
      String? adminToken = await currentAdmin.getIdToken();

      // Create a secondary Firebase Auth instance
      FirebaseAuth secondaryAuth = FirebaseAuth.instance;

      // Create the new user
      UserCredential userCredential = await secondaryAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Sign out from the secondary instance, not affecting the main instance
      await secondaryAuth.signOut();

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Failed to create user: ${e.message}');
      rethrow;
    }
  }
}

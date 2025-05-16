import 'package:cl_fashion/model/user_model.dart';
import 'package:cl_fashion/screen/login.dart';
import 'package:cl_fashion/screen/screen_admin.dart';
import 'package:cl_fashion/screen/screen_emp.dart';
import 'package:cl_fashion/service/auth_service.dart';
import 'package:cl_fashion/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  final AuthService _auth = AuthService();
  final DatabaseService _database = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            print("AuthWrapper: No user logged in, showing login screen");
            return LoginScreen();
          } else {
            print("AuthWrapper: User logged in with ID: ${user.uid}, checking user type");
            // Check user type in Firestore and route accordingly
            return FutureBuilder<UserModel?>(
              future: _database.getUserData(user.uid),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                if (userSnapshot.hasData && userSnapshot.data != null) {
                  final UserModel userData = userSnapshot.data!;
                  print("User type auth.dart: ${userData.type}");
                  // Route based on user type
                  if (userData.type == 'admin') {
                    print("AuthWrapper: Routing to Admin Dashboard for user ${userData.id}");
                    return const HomeAdmin();
                  } else {
                    print("AuthWrapper: Routing to Employee Dashboard for user ${userData.id}");
                    return const HomeEmployee();
                  }
                }
                return Scaffold(
                  body: Center(
                    child: Text('User type unknown'),
                  ),
                );
                // Default to employee view if user exists but type is unknown
              },
            );
          }
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

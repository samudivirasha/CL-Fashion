import 'package:cl_fashion/screen/home.dart';
import 'package:cl_fashion/screen/login.dart';
import 'package:cl_fashion/service/auth_service.dart';
import 'package:cl_fashion/test.dart';

import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          Test();
          if (user == null) {
            return LoginScreen();
          } else {
            return HomeScreen();
          }
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

// login_screen.dart
import 'package:cl_fashion/service/auth_service.dart';
import 'package:cl_fashion/utl/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    Future<String?> _authUser(LoginData data) async {
      try {
        await _auth.signInWithEmailAndPassword(data.name, data.password);
        Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        return 'Password does not match';
      }
    }

    return Scaffold(
      body: FlutterLogin(
        onLogin: _authUser,
        logo: 'assets/cl.png',
        hideForgotPasswordButton: true,
        title: "CL Fashion",
        onRecoverPassword: (String) {},
        theme: LoginTheme(
          primaryColor: const Color.fromARGB(255, 38, 38, 38),
          titleStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          inputTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Color.fromARGB(15, 38, 38, 38),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide.none,
            ),
          ),
          buttonStyle: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          buttonTheme: const LoginButtonTheme(
            backgroundColor: Color.fromARGB(255, 255, 192, 34),
            highlightColor: Color.fromARGB(255, 255, 222, 34),
            splashColor: Color.fromARGB(255, 255, 222, 34),
          ),
        ),
      ),
    );
  }
}

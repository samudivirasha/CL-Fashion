import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  // add paddin to TextFormField
  inputDecorationTheme: const InputDecorationTheme(
    suffixStyle: TextStyle(color: Colors.white),
    contentPadding: EdgeInsets.all(20),
    hintStyle: TextStyle(color: Colors.white),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2),
      borderRadius: BorderRadius.all(
        Radius.circular(12),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2),
      borderRadius: BorderRadius.all(
        Radius.circular(12),
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(12),
      ),
    ),
    floatingLabelStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.grey, // Keeps label color when typing
    ),
    labelStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.grey,
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white), // Default text color
    // bodyLarge: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
    labelLarge: TextStyle(color: Colors.white),
  ),
);

Color primaryColor = const Color.fromARGB(255, 38, 38, 38);
Color secondaryColor = const Color.fromARGB(255, 52, 54, 63);
Color textColor = const Color.fromARGB(255, 212, 212, 212);

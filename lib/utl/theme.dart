import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(12),
      ),
    ),
    labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  ),
);

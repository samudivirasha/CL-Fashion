import 'package:cl_fashion/auth.dart';
import 'package:cl_fashion/firebase_options.dart';
import 'package:cl_fashion/screen/home.dart';
import 'package:cl_fashion/screen/login.dart';
import 'package:cl_fashion/utl/theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'CL Fashion',
          theme: theme,
          initialRoute: '/',
          // Use onGenerateRoute to have more control over navigation
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(builder: (_) => AuthWrapper());
              case '/login':
                return MaterialPageRoute(builder: (_) => LoginScreen());
              case '/home':
                // Always go through AuthWrapper to determine correct screen
                return MaterialPageRoute(builder: (_) => AuthWrapper());
              default:
                return MaterialPageRoute(builder: (_) => AuthWrapper());
            }
          },
        );
      },
    );
  }
}

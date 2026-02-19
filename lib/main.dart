import 'package:flutter/material.dart';
import 'package:qhs_mobile/auth/login_page.dart';
import 'package:qhs_mobile/home/home_page.dart';
import 'package:qhs_mobile/middleware/auth_guard.dart';
import 'package:qhs_mobile/splash/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QHS Mobile App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const AuthGuard(
          child: MyHomePage(title: 'QHS Mobile App')
          ),
      },
    );
  }
}

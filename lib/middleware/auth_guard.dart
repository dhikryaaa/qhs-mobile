import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGuard extends StatefulWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool isChecking = true;

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, "/login");
    } else {
      setState(() {
        isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isChecking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return widget.child;
  }
}

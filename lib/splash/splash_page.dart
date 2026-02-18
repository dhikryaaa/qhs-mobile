import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qhs_mobile/auth/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();

    // Pindah halaman setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {

      if (!mounted) return; // Cek apakah widget masih terpasang sebelum navigasi

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()), // Ganti dengan halaman utama Anda
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4077AE),
              Color(0xFF0E5EAD),
            ],
          ),
        ),
        child: Stack(
          children: [

            /// 🔵 LOGO TENGAH
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ganti dengan Image.asset kalau pakai PNG
                  Image.asset(
                    "assets/logo_container.png",
                    width: 200,
                  ),
                ],
              ),
            ),

            /// 🔵 SPONSOR BAWAH
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Image.asset(
                    "assets/sponsor_container.png",
                    width: 106,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

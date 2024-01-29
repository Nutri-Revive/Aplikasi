import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nutri_revive/login_page.dart';


class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // buat Timer yang akan berjalan setelah 3 detik
    Timer(const Duration(seconds: 2), () {
      // ganti layar loading dengan layar login
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              const LoginPage())); // asumsikan Anda memiliki kelas LoginScreen
    });
    return Scaffold(
      backgroundColor:
          Color(0xFF5C7557), // warna latar belakang gelap hijau
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png"), // gambar logo dari aset
          ],
        ),
      ),
    );
  }
}

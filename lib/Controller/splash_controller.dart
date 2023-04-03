import 'package:chat_app/View/HomeScreen.dart';
import 'package:chat_app/View/Login_screen.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreenController {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if(user != null){
      Timer(
          const Duration(seconds: 3),
              () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const HomeScreen()))); // PostScreen())
    }
    else {
      Timer(
          const Duration(seconds: 3),
              () =>
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen())));
    }
  }
}

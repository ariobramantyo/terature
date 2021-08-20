import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:terature/screen/home_screen.dart';
import 'package:terature/screen/login_screen.dart';
import 'package:terature/screen/splash_screen.dart';
import 'package:terature/services/auth_service.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.firebaseUserStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User? user = snapshot.data;
          return HomeScreen(
            user: user,
          );
        }
        return LoginScreen();
      },
    );
  }
}

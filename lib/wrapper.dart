import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:terature/controllers/logged_user_controller.dart';
import 'package:terature/screen/home_screen.dart';
import 'package:terature/screen/login_screen.dart';
import 'package:terature/services/auth_service.dart';

class Wrapper extends StatelessWidget {
  Wrapper({Key? key}) : super(key: key);

  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.firebaseUserStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeScreen(
            user: snapshot.data,
          );
        }
        return LoginScreen();
      },
    );
  }
}

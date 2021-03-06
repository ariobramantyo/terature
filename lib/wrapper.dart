import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:terature/controllers/logged_user_controller.dart';
import 'package:terature/screen/nav_bar.dart';
import 'package:terature/screen/login_screen.dart';
import 'package:terature/services/auth_service.dart';
import 'package:terature/services/firestore_service.dart';

class Wrapper extends StatelessWidget {
  Wrapper({Key? key}) : super(key: key);

  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.firebaseUserStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //mengambil user data dan semua task user yang sedang login dari firestore, serta menset isLoggedIn menjadi true
          FirestoreService.firstInitializationAfterLogin(snapshot.data);

          return HomeScreen(
            user: snapshot.data,
          );
        }
        return LoginScreen();
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:terature/controllers/logged_user_controller.dart';
import 'package:terature/services/auth_service.dart';

class Settings extends StatelessWidget {
  Settings({Key? key}) : super(key: key);

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: IconButton(
              onPressed: () async {
                userController.userTask.clear();
                await AuthService.signOut();
              },
              icon: Icon(Icons.logout))),
    );
  }
}

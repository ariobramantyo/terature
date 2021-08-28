import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:terature/controllers/logged_user_controller.dart';
import 'package:terature/controllers/navbar_controller.dart';
import 'package:terature/services/auth_service.dart';
import 'package:terature/services/notification.dart';

class Settings extends StatelessWidget {
  Settings({Key? key}) : super(key: key);

  final userController = Get.find<UserController>();
  final navBarController = Get.find<NavBarController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: IconButton(
              onPressed: () async {
                //menghapus semua task user yang sedang log in
                userController.userTask.clear();

                //menyimpan status user logged in menjadi false
                final box = GetStorage();
                box.write('isLoggedIn', false);

                //menset navbar menjadi 1(home) kembali
                navBarController.currentTab.value = 0;

                //membatalkan smeua notifikasi
                await NotificationService.cancelAllNotifications();

                //autentifikasi log out
                await AuthService.signOut();
              },
              icon: Icon(Icons.logout))),
    );
  }
}

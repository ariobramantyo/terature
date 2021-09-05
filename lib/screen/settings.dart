import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:terature/constant/color.dart';
import 'package:terature/controllers/edit_data_controlller.dart';
import 'package:terature/controllers/logged_user_controller.dart';
import 'package:terature/controllers/navbar_controller.dart';
import 'package:terature/controllers/notification_controller.dart';
import 'package:terature/controllers/theme_controller.dart';
import 'package:terature/screen/edit_screen.dart';
import 'package:terature/services/auth_service.dart';
import 'package:terature/services/firestore_service.dart';
import 'package:terature/services/notification.dart';

class Settings extends StatelessWidget {
  Settings({Key? key}) : super(key: key);

  final notificationController = Get.put(NotificationController());
  final editDataController = Get.put(EditDataController());
  final userController = Get.find<UserController>();
  final navBarController = Get.find<NavBarController>();
  final themeController = Get.find<AppTheme>();

  TextStyle textStyle = TextStyle(
      fontFamily: 'Poppins', fontSize: 19, fontWeight: FontWeight.w500);

  String getUserMiddleName(String name) {
    String secondName = '';
    String firsName = name.split(' ').first;

    name.split(' ').forEach((element) {
      if (element != firsName) {
        secondName += '$element ';
      }
    });

    return secondName;
  }

  void logout() async {
    //menghapus semua task user yang sedang log in
    userController.userTask.clear();

    //menyimpan status user logged in menjadi false
    final box = GetStorage();
    box.write('isLoggedIn', false);

    //membatalkan smeua notifikasi
    await NotificationService.cancelAllNotifications();

    //autentifikasi log out
    await AuthService.signOut();

    //menset navbar menjadi 0(home) kembali
    navBarController.currentTab.value = 0;
  }

  Widget dataContainer(String title, String content, bool isEditable,
      void Function() func, Color color) {
    return Container(
      height: 60,
      width: double.infinity,
      // margin: EdgeInsets.only(bottom: 25),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textStyle.copyWith(
                    fontSize: 12,
                    color: themeController.isDarkMode.value
                        ? Color(0xffAFAFAF)
                        : AppColor.lightPrimaryColor),
              ),
              Text(content == '' ? 'no nomber' : content,
                  style: textStyle.copyWith(fontSize: 15)),
            ],
          ),
          if (isEditable)
            GestureDetector(
              onTap: func,
              child: Container(
                height: 24,
                width: 45,
                decoration: BoxDecoration(
                    color: themeController.isDarkMode.value
                        ? AppColor.darkFormFillColor
                        : AppColor.lightSecondaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    'edit',
                    style: textStyle.copyWith(
                        color: AppColor.lightPrimaryColor, fontSize: 15),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
        'BUILD SETTINGS ======================================================');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: textStyle.copyWith(fontSize: 23),
        ),
        backwardsCompatibility: false,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Obx(
                        () => Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff353535),
                          ),
                          child: userController.loggedUser.value.imageUrl == ''
                              ? Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 47,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                      userController
                                              .loggedUser.value.imageUrl ??
                                          'https://ppa-feui.com/wp-content/uploads/2013/01/nopict-300x300.png',
                                      fit: BoxFit.fill),
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: -6,
                        right: -6,
                        child: GestureDetector(
                          onTap: () async {
                            // var user = FirebaseAuth.instance.currentUser;
                            await editDataController
                                .updateUserPhoto(
                                    userController.loggedUser.value.uid!)
                                .then((imageUrl) {
                              if (imageUrl != '') {
                                userController.loggedUser.update(
                                  (user) {
                                    user!.imageUrl = imageUrl;
                                  },
                                );
                                userController.loggedUser.refresh();
                                FirestoreService.updateUserPhoto(
                                    userController.loggedUser.value.uid!,
                                    imageUrl);
                              }
                            });
                          },
                          child: Container(
                            height: 33,
                            width: 33,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff353535).withOpacity(0.56)),
                            child: Icon(
                              Icons.photo_camera,
                              color: Color(0xffFF810C),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: 14),
                  Obx(() => Container(
                        width: 160,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userController.loggedUser.value.name!
                                  .split(' ')
                                  .first,
                              style: textStyle,
                            ),
                            Text(
                                getUserMiddleName(
                                    userController.loggedUser.value.name!),
                                style: textStyle.copyWith(
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      )),
                ],
              ),
              IconButton(
                  onPressed: () {
                    Get.to(EditScreen(
                        type: 'Name',
                        content: userController.loggedUser.value.name!));
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.amber,
                  ))
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dark mode',
                style: textStyle.copyWith(fontSize: 16),
              ),
              Obx(() => Switch(
                  value: themeController.isDarkMode.value,
                  activeColor: Color(0xffFF810C),
                  trackColor: themeController.isDarkMode.value
                      ? MaterialStateProperty.all(Color(0xff585858))
                      : MaterialStateProperty.all(
                          AppColor.lightSecondaryColor.withOpacity(0.5)),
                  onChanged: (_) {
                    themeController.changeTheme();
                    print('sesudah:  ${themeController.isDarkMode.value}');
                  })),
            ],
          ),
          SizedBox(height: 10),
          Obx(
            () => dataContainer(
                'Phone Number',
                userController.loggedUser.value.no ?? 'no number',
                true,
                () => Get.to(EditScreen(
                    type: 'Phone number',
                    content:
                        userController.loggedUser.value.no ?? 'no number')),
                themeController.isDarkMode.value
                    ? AppColor.darkScondaryColor
                    : AppColor.lightFormFillColor),
          ),
          SizedBox(height: 25),
          dataContainer(
              'Email',
              userController.loggedUser.value.email ?? '',
              false,
              () {},
              themeController.isDarkMode.value
                  ? AppColor.darkScondaryColor
                  : AppColor.lightFormFillColor),
          // dataContainer('',
          // userController.loggedUser.value.no ?? 'no number', false),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Notification',
                style: textStyle.copyWith(fontSize: 16),
              ),
              Obx(() => Switch(
                  value: notificationController.allowNotification.value,
                  activeColor: Color(0xffFF810C),
                  trackColor: themeController.isDarkMode.value
                      ? MaterialStateProperty.all(Color(0xff585858))
                      : MaterialStateProperty.all(
                          AppColor.lightSecondaryColor.withOpacity(0.5)),
                  onChanged: (_) {
                    notificationController.changeNotificationStatus(
                        FirebaseAuth.instance.currentUser);
                    print(notificationController.allowNotification.value);
                  })),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => logout(),
              child: Container(
                height: 40,
                width: 117,
                margin: EdgeInsets.only(top: 31),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: themeController.isDarkMode.value
                        ? AppColor.darkScondaryColor
                        : AppColor.lightPrimaryColor),
                child: Center(
                  child: Text(
                    'Log Out',
                    style:
                        textStyle.copyWith(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:terature/controllers/navbar_controller.dart';
import 'package:terature/screen/dashboard.dart';
import 'package:terature/screen/settings.dart';
import 'package:terature/screen/widgets/add_task.dart';

class HomeScreen extends StatelessWidget {
  final User? user;
  HomeScreen({Key? key, required this.user}) : super(key: key);

  final PageStorageBucket bucket = PageStorageBucket();

  final navController = Get.put(NavBarController());

  List screens = [
    Dashboard(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    print(
        'BUILD==========================================================================================');
    return Scaffold(
      backgroundColor: Color(0xff353535),
      bottomNavigationBar: Obx(
        () => BottomAppBar(
          color: navController.currentTab.value == 0
              ? Color(0xff353535)
              : Color(0xff151515),
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          child: Container(
            margin: EdgeInsets.only(bottom: 15, left: 40, right: 40),
            height: 61,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Color(0xff000000),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                    minWidth: 30,
                    onPressed: () {
                      navController.pageChange(0);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10),
                        Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 26,
                        ),
                        SizedBox(height: 5),
                        Obx(() => Container(
                              height: 5,
                              width: 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: navController.currentTab.value == 0
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                            ))
                      ],
                    )),
                MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        enableDrag: false,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30))),
                        builder: (context) => AddTask(),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xffFF810C),
                            Color(0xffFFB066),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    )),
                MaterialButton(
                    minWidth: 30,
                    onPressed: () {
                      navController.pageChange(1);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10),
                        Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 26,
                        ),
                        SizedBox(height: 5),
                        Obx(() => Container(
                              height: 5,
                              width: 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: navController.currentTab.value == 1
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                            ))
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() => PageStorage(
          bucket: bucket, child: screens[navController.currentTab.value])),
    );
  }
}

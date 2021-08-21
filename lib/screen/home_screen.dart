import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:terature/controllers/navbar_controller.dart';
import 'package:terature/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final User? user;
  HomeScreen({Key? key, required this.user}) : super(key: key);

  final PageStorageBucket bucket = PageStorageBucket();
  final navController = Get.put(NavBarController());

  @override
  Widget build(BuildContext context) {
    print(
        'BUILD==========================================================================================');
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        backgroundColor: Color(0xFFFF7A00),
        actions: [
          IconButton(
              onPressed: () async {
                await AuthService.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xffFF7A00),
        elevation: 0,
        shape: CircleBorder(side: BorderSide(width: 4, color: Colors.white)),
        child: Icon(
          Icons.add,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          margin: EdgeInsets.only(bottom: 20, left: 15, right: 15),
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Color(0xffFFA726),
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  // color: Colors.blueGrey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          minWidth: 30,
                          onPressed: () {
                            navController.pageChange(0);
                          },
                          child: Icon(
                            Icons.home,
                            color: Colors.white,
                            size: 26,
                          )),
                      MaterialButton(
                          minWidth: 30,
                          onPressed: () {
                            navController.pageChange(1);
                          },
                          child: Icon(
                            Icons.email,
                            color: Colors.white,
                            size: 26,
                          )),
                    ],
                  ),
                ),
              ),
              Flexible(
                  flex: 1,
                  child: Container(
                      // color: Colors.red,
                      )),
              Flexible(
                flex: 2,
                child: Container(
                  // color: Colors.green,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            navController.pageChange(2);
                          },
                          child: Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 26,
                          )),
                      MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            navController.pageChange(3);
                          },
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 26,
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Obx(() => PageStorage(
          bucket: bucket,
          child: navController.screens[navController.currentTab.value])),
      // body: (user!.displayName == null)
      //     ? FutureBuilder<QuerySnapshot>(
      //         future: FirebaseFirestore.instance
      //             .collection('user')
      //             .doc(user!.uid)
      //             .collection('data')
      //             .get(),
      //         builder: (context, snapshot) {
      //           if (snapshot.hasData) {
      //             return Center(
      //               child: Text(snapshot.data!.docs[0]['name']),
      //             );
      //           }
      //           return Center(child: CircularProgressIndicator());
      //         },
      //       )
      //     : Center(
      //         child: Text(user!.displayName ?? ''),
      //       ),
    );
  }
}

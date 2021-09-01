import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:custom_check_box/custom_check_box.dart';
import 'package:get/get.dart';
import 'package:terature/controllers/calendar_controller.dart';
import 'package:terature/controllers/logged_user_controller.dart';
import 'package:terature/controllers/tab_bar_controller.dart';
import 'package:terature/model/task.dart';
import 'package:terature/services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:terature/services/notification.dart';
import 'package:timezone/data/latest.dart' as tz;

class Dashboard extends StatefulWidget {
  // Dashboard({Key? key}) : super(key: key);

  // final User? user;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  final cldrController = Get.put(CalendarController());
  final tabBarController = Get.put(TabBarController());
  final userController = Get.find<UserController>();

  TextStyle textStyle = TextStyle(
      fontFamily: 'Poppins', fontSize: 19, fontWeight: FontWeight.w500);

  DateTime _focusedDay = DateTime.now();

  late TabController _tabController;

  Widget checkboxTask(Task task, String docId, String collection) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${task.judul} | ${task.jamDeadline}',
          style: TextStyle(
              fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w400),
        ),
        CustomCheckBox(
          value: task.isDone,
          onChanged: (_) {
            FirestoreService.checkTask(
                FirebaseAuth.instance.currentUser, collection, docId, task);
            if (task.isDone) {
              Get.snackbar('Task kembali dikerjakan',
                  'task ${task.judul} dipindahkan ke dalam tab on going');
            } else {
              Get.snackbar('Task selesai',
                  'task ${task.judul} dipindahkan ke dalam tab completed');
            }
          },
          checkBoxSize: 18,
          checkedFillColor: Color(0xffFF810C),
          borderRadius: 5,
          borderColor: Color(0xffFF810C),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    tz.initializeTimeZones();
    NotificationService.initialize();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff000000),
        body: Column(
          children: [
            //header
            SafeArea(
                child: Padding(
              padding: EdgeInsets.only(left: 23, right: 28, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEEE, d \nMMMM').format(_focusedDay),
                    style: textStyle.copyWith(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Obx(() => Container(
                        height: 47,
                        width: 47,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff353535),
                        ),
                        child: userController.loggedUser.value.imageUrl == ''
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: Icon(
                                  Icons.person,
                                  size: 47,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                    userController.loggedUser.value.imageUrl ??
                                        'https://ppa-feui.com/wp-content/uploads/2013/01/nopict-300x300.png',
                                    fit: BoxFit.fill),
                              ),
                      ))
                ],
              ),
            )),
            SizedBox(height: 19),
            CalendarTimeline(
              initialDate: cldrController.calendarDateSelected,
              firstDate: DateTime.utc(2010, 10, 16),
              lastDate: DateTime.utc(2030, 3, 14),
              onDateSelected: (date) {
                cldrController.calendarDateSelected = date!;
                cldrController.onDateSelected(date);
                print(cldrController.dateNow);
              },
              leftMargin: 20,
              // showYears: true,
              monthColor: Color(0xff7e7e7e),
              dayColor: Color(0xff7e7e7e),
              activeDayColor: Colors.white,
              activeBackgroundDayColor: Color(0xffFF7C02),
              dotsColor: Color(0xFF333A47),
              locale: 'en_ISO',
            ),

            SizedBox(height: 22),

            // Container(
            //   height: 60,
            //   // margin: EdgeInsets.symmetric(horizontal: 20),
            //   decoration: BoxDecoration(
            //       color: Color(0xff353535),
            //       borderRadius:
            //           BorderRadius.vertical(top: Radius.circular(30))),
            //   child: TabBar(
            //     unselectedLabelColor: Colors.white,
            //     indicatorSize: TabBarIndicatorSize.label,
            //     labelColor: Colors.white,
            //     labelStyle:
            //         TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            //     indicator: BoxDecoration(
            //       border: Border(
            //         bottom: BorderSide(
            //           width: 5,
            //           color: Colors.amber,
            //         ),
            //       ),
            //     ),
            //     controller: _tabController,
            //     tabs: [
            //       Tab(
            //         child: Align(
            //             alignment: Alignment.center,
            //             child: Text(
            //               'On going',
            //             )),
            //       ),
            //       Tab(
            //         child: Align(
            //             alignment: Alignment.center,
            //             child: Text(
            //               'Completed',
            //             )),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Color(0xff353535),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => GestureDetector(
                        onTap: () {
                          tabBarController.changeTabBar(0);
                          print(userController.userTask);
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 150),
                          height: 23,
                          width: 97,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: tabBarController.tabBarSelected.value == 0
                                ? Color(0xffFF7C02)
                                : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              'On Going',
                              style: textStyle.copyWith(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(width: 19),
                  Obx(() => GestureDetector(
                        onTap: () {
                          tabBarController.changeTabBar(1);
                          print(userController.userTask);
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 150),
                          height: 23,
                          width: 97,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: tabBarController.tabBarSelected.value == 1
                                ? Color(0xffFF7C02)
                                : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              'Completed',
                              style: textStyle.copyWith(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
            Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: Color(0xff353535),
                  child: Obx(() {
                    return tabBarController.tabBarSelected.value == 0
                        ? StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('user')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('task')
                                .where('isDone', isEqualTo: false)
                                .where('tanggalDibuat',
                                    isEqualTo: cldrController.dateNow.value)
                                // .orderBy('jamDeadline')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    var task = Task.fromSnapshot(
                                        snapshot.data!.docs[index]
                                            as QueryDocumentSnapshot<
                                                Map<String, dynamic>>);
                                    return Column(
                                      children: [
                                        Dismissible(
                                          key: UniqueKey(),
                                          background: Container(
                                            color: Color(0xff353535),
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'completed',
                                                style: textStyle.copyWith(
                                                    fontSize: 13,
                                                    color: Color(0xffFF7C02)),
                                              ),
                                            ),
                                          ),
                                          secondaryBackground: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text('Delete',
                                                style: textStyle.copyWith(
                                                    fontSize: 13,
                                                    color: Colors.white)),
                                          ),
                                          onDismissed: (direction) {
                                            if (direction ==
                                                DismissDirection.startToEnd) {
                                              FirestoreService.checkTask(
                                                  FirebaseAuth
                                                      .instance.currentUser,
                                                  cldrController.dateNow.value,
                                                  snapshot.data!.docs[index].id,
                                                  task);

                                              //hapus notifikasi task yang diselesaikan
                                              NotificationService
                                                  .cancelNotificationById(
                                                      task.id);
                                            } else {
                                              FirestoreService.deleteTask(
                                                FirebaseAuth
                                                    .instance.currentUser,
                                                cldrController.dateNow.value,
                                                snapshot.data!.docs[index].id,
                                              );

                                              //hapus notofikasi task yang dihapus
                                              NotificationService
                                                  .cancelNotificationById(
                                                      task.id);

                                              Get.snackbar(
                                                  'Task berhasil dihapus',
                                                  'task ${task.judul} telah dihapus dari daftar todo list anda',
                                                  colorText: Colors.white);
                                            }
                                          },
                                          child: Container(
                                              width: double.infinity,
                                              height: 50,
                                              padding: EdgeInsets.only(
                                                  left: 15, right: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Color(0xff636363)),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      task.judul,
                                                      style: textStyle.copyWith(
                                                          fontSize: 16,
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      task.jamDeadline,
                                                      style: textStyle.copyWith(
                                                          fontSize: 16,
                                                          color: Color(
                                                              0xffFF7C02)),
                                                    ),
                                                  ])
                                              // checkboxTask(
                                              //   task,
                                              //   snapshot.data!.docs[index].id,
                                              //   cldrController.dateNow.value,
                                              // ),
                                              ),
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    );
                                  },
                                );
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          )
                        : StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('user')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('task')
                                .where('isDone', isEqualTo: true)
                                .where('tanggalDibuat',
                                    isEqualTo: cldrController.dateNow.value)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    var task = Task.fromSnapshot(
                                        snapshot.data!.docs[index]
                                            as QueryDocumentSnapshot<
                                                Map<String, dynamic>>);
                                    return Column(
                                      children: [
                                        Dismissible(
                                          key: UniqueKey(),
                                          background: Container(
                                            color: Color(0xff353535),
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Uncompleted',
                                                style: textStyle.copyWith(
                                                    fontSize: 13,
                                                    color: Color(0xffFF7C02)),
                                              ),
                                            ),
                                          ),
                                          secondaryBackground: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text('Delete',
                                                style: textStyle.copyWith(
                                                    fontSize: 13,
                                                    color: Colors.white)),
                                          ),
                                          onDismissed: (direction) {
                                            if (direction ==
                                                DismissDirection.startToEnd) {
                                              FirestoreService.checkTask(
                                                  FirebaseAuth
                                                      .instance.currentUser,
                                                  cldrController.dateNow.value,
                                                  snapshot.data!.docs[index].id,
                                                  task);

                                              //mengaktifkan kembali notifikasi dari task yang kembali dikerjakan
                                              NotificationService
                                                  .showScheduleNotification(
                                                      task, 'terature');
                                            } else {
                                              FirestoreService.deleteTask(
                                                FirebaseAuth
                                                    .instance.currentUser,
                                                cldrController.dateNow.value,
                                                snapshot.data!.docs[index].id,
                                              );

                                              //hapus notofikasi task yang dihapus
                                              NotificationService
                                                  .cancelNotificationById(
                                                      task.id);

                                              Get.snackbar(
                                                  'Task berhasil dihapus',
                                                  'task ${task.judul} telah dihapus dari daftar todo list anda',
                                                  colorText: Colors.white);
                                            }
                                          },
                                          child: Container(
                                              width: double.infinity,
                                              height: 50,
                                              padding: EdgeInsets.only(
                                                  left: 15, right: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Color(0xff636363)),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      task.judul,
                                                      style: textStyle.copyWith(
                                                          fontSize: 16,
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      task.jamDeadline,
                                                      style: textStyle.copyWith(
                                                          fontSize: 16,
                                                          color: Color(
                                                              0xffFF7C02)),
                                                    ),
                                                  ])

                                              // checkboxTask(
                                              //   task,
                                              //   snapshot.data!.docs[index].id,
                                              //   cldrController.dateNow.value,
                                              // ),
                                              ),
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    );
                                  },
                                );
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );
                  })
                  // Obx(() {
                  //   if (tabBarController.tabBarSelected.value == 0) {
                  //     return
                  //   } else {
                  //     return
                  //   }
                  // })
                  // TabBarView(
                  //   controller: _tabController,
                  //   children: [

                  //     // Obx(
                  //     //   () =>
                  //     // ),
                  //     // Obx(
                  //     //   () =>
                  //     // ),
                  //   ],
                  // ),
                  ),
            ),
          ],
        ));
  }
}

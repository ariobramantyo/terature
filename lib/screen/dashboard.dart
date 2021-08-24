import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:custom_check_box/custom_check_box.dart';
import 'package:get/get.dart';
import 'package:terature/controllers/calendar_controller.dart';
import 'package:terature/controllers/dashboard_controller.dart';
import 'package:terature/model/task.dart';
import 'package:terature/services/firestore_service.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  // Dashboard({Key? key}) : super(key: key);

  // final User? user;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  final dashboardController = Get.put(DashboardController());
  final cldrController = Get.put(CalendarController());

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        //header
        SafeArea(
            child: Padding(
          padding: EdgeInsets.only(left: 23, right: 28, top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('EEEE, d MMM').format(_focusedDay),
                  style: textStyle),
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Color(0xffFF6230), Color(0xffFF9330)])),
                child: Icon(
                  Icons.notifications_none_outlined,
                  color: Colors.white,
                ),
              )
            ],
          ),
        )),
        SizedBox(height: 20),
        CalendarTimeline(
          initialDate: _focusedDay,
          firstDate: DateTime.utc(2010, 10, 16),
          lastDate: DateTime.utc(2030, 3, 14),
          onDateSelected: (date) {
            cldrController.onDateSelected(date!);
            print(cldrController.dateNow);
          },
          leftMargin: 20,
          // showYears: true,
          monthColor: Colors.blueGrey,
          dayColor: Colors.grey,
          activeDayColor: Colors.white,
          activeBackgroundDayColor: Color(0xffFFA726),
          dotsColor: Color(0xFF333A47),
          // selectableDayPredicate: (date) => date.day != 23,
          locale: 'en_ISO',
        ),

        SizedBox(height: 0),

        Container(
          height: 60,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: TabBar(
            unselectedLabelColor: Colors.grey[400],
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.amber,
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 5,
                  color: Colors.amber,
                ),
              ),
            ),
            controller: _tabController,
            tabs: [
              Tab(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'On going',
                    )),
              ),
              Tab(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Completed',
                    )),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: Get.height * 0.53,
          // color: Colors.blueGrey,
          child: TabBarView(
            controller: _tabController,
            children: [
              Obx(
                () => StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('user')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection(cldrController.dateNow.value)
                      .where('isDone', isEqualTo: false)
                      // .orderBy('jamDeadline')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 10),
                        // shrinkWrap: true,
                        // physics: ClampingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var task = Task.fromSnapshot(snapshot
                                  .data!.docs[index]
                              as QueryDocumentSnapshot<Map<String, dynamic>>);
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (_) {
                              FirestoreService.deleteTask(
                                FirebaseAuth.instance.currentUser,
                                cldrController.dateNow.value,
                                snapshot.data!.docs[index].id,
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              padding: EdgeInsets.only(left: 15, right: 10),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.amber[100]),
                              child: checkboxTask(
                                task,
                                snapshot.data!.docs[index].id,
                                cldrController.dateNow.value,
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              Obx(
                () => StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('user')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection(cldrController.dateNow.value)
                      .where('isDone', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 10),
                        // shrinkWrap: true,
                        // physics: ClampingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var task = Task.fromSnapshot(snapshot
                                  .data!.docs[index]
                              as QueryDocumentSnapshot<Map<String, dynamic>>);
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (_) {
                              FirestoreService.deleteTask(
                                FirebaseAuth.instance.currentUser,
                                cldrController.dateNow.value,
                                snapshot.data!.docs[index].id,
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              padding: EdgeInsets.only(left: 15, right: 10),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.amber[100]),
                              child: checkboxTask(
                                task,
                                snapshot.data!.docs[index].id,
                                cldrController.dateNow.value,
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

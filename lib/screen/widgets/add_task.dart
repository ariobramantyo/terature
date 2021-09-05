import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:terature/constant/color.dart';
import 'package:terature/controllers/bottom_sheet.dart';
import 'package:terature/controllers/calendar_controller.dart';
import 'package:terature/controllers/theme_controller.dart';
import 'package:terature/model/task.dart';
import 'package:terature/services/firestore_service.dart';
import 'package:terature/services/notification.dart';

class AddTask extends StatelessWidget {
  final sheetController = Get.put(BottomSheetController());
  final cldrController = Get.find<CalendarController>();
  final themeController = Get.find<AppTheme>();

  int year = int.parse(DateTime.now().toString().substring(0, 4));
  int month = int.parse(DateTime.now().toString().substring(5, 7));
  int day = int.parse(DateTime.now().toString().substring(8, 10));

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: themeController.isDarkMode.value
            ? Colors.white
            : AppColor.lightPrimaryColor);
    print(
        'BUILD ADD TASK ======================================================');

    return Obx(() => Container(
          decoration: BoxDecoration(
              color: themeController.isDarkMode.value
                  ? Color(0xff151515)
                  : AppColor.lightBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.close,
                    color: themeController.isDarkMode.value
                        ? AppColor.lightPrimaryColor
                        : AppColor.darkBackgroundColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create new\ntask',
                      style: textStyle.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 21),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Task name',
                          style: textStyle,
                        ),
                        SizedBox(height: 11),
                        Container(
                          height: 36,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            textAlignVertical: TextAlignVertical.bottom,
                            controller: sheetController.taskController,
                            style: textStyle.copyWith(
                                color: themeController.isDarkMode.value
                                    ? Colors.white
                                    : Colors.black),
                            decoration: InputDecoration(
                                hintText: 'Task title',
                                hintStyle: textStyle.copyWith(
                                    color: themeController.isDarkMode.value
                                        ? Colors.white
                                        : Colors.black),
                                filled: true,
                                fillColor: themeController.isDarkMode.value
                                    ? Color(0xff636363)
                                    : AppColor.lightFormFillColor,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide.none)),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 21),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Task deadline',
                          style: textStyle,
                        ),
                        SizedBox(height: 11),
                        GestureDetector(
                            onTap: () {
                              DatePicker.showTimePicker(
                                context,
                                theme: DatePickerTheme(
                                    itemStyle: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: themeController.isDarkMode.value
                                            ? Colors.white
                                            : Colors.black),
                                    cancelStyle: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: themeController.isDarkMode.value
                                            ? Colors.white
                                            : Colors.black),
                                    backgroundColor:
                                        themeController.isDarkMode.value
                                            ? AppColor.darkBackgroundColor
                                            : AppColor.lightBackgroundColor,
                                    doneStyle: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Color(0xffFF810C))),
                                showSecondsColumn: false,
                                onConfirm: (date) {
                                  sheetController.dateSubmit.value =
                                      date.toString();
                                  sheetController.onTimeSubmit(date.toString());
                                  print('time $date');
                                },
                              );
                            },
                            child: Container(
                              height: 36,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: themeController.isDarkMode.value
                                      ? Color(0xff636363)
                                      : AppColor.lightFormFillColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    sheetController.timeSubmit.value,
                                    style: textStyle.copyWith(
                                        // fontSize: 13,
                                        color: themeController.isDarkMode.value
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  Icon(Icons.keyboard_arrow_down,
                                      color: themeController.isDarkMode.value
                                          ? Colors.white
                                          : Colors.black)
                                ],
                              ),
                            )),
                      ],
                    ),
                    SizedBox(height: 46),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            if (sheetController.timeSubmit.value != 'Time' &&
                                sheetController.taskController.text != '') {
                              if (DateTime.parse(
                                      sheetController.dateSubmit.value)
                                  .isAfter(DateTime.now())) {
                                var task = Task(
                                  id: Random().nextInt(10000),
                                  judul: sheetController.taskController.text,
                                  tanggalDeadline:
                                      sheetController.dateSubmit.value,
                                  jamDeadline: sheetController.timeSubmit.value,
                                  tanggalDibuat: cldrController.dateNow.value,
                                );

                                FirestoreService.addTask(
                                  FirebaseAuth.instance.currentUser,
                                  task,
                                );

                                NotificationService.showScheduleNotification(
                                    task, 'terature');

                                Get.back();
                              } else {
                                Get.defaultDialog(
                                  title: 'Error',
                                  middleText:
                                      'Deadline task must be a future time. Try input a valid deadline time',
                                  textCancel: 'back',
                                  onCancel: () => Get.back(),
                                  backgroundColor: Color(0xff353535),
                                  cancelTextColor: Color(0xffFF7C02),
                                  buttonColor: Color(0xffFF7C02),
                                  titleStyle: TextStyle(color: Colors.white),
                                  middleTextStyle:
                                      TextStyle(color: Colors.white),
                                );
                              }

                              sheetController.dateSubmit.value = 'Tanggal';
                              sheetController.timeSubmit.value = 'Time';
                              sheetController.taskController.text = '';
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(500, 49),
                              primary: Color(0xffFF810C),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Text(
                            'Buat',
                            style: textStyle.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

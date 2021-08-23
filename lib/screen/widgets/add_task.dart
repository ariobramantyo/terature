import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:terature/controllers/bottom_sheet.dart';
import 'package:terature/controllers/calendar_controller.dart';
import 'package:terature/model/task.dart';
import 'package:terature/services/firestore_service.dart';

class AddTask extends StatelessWidget {
  // AddTask({Key? key}) : super(key: key);

  TextStyle textStyle = TextStyle(
      fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w400);

  final sheetController = Get.put(BottomSheetController());
  final cldrController = Get.find<CalendarController>();

  int year = int.parse(DateTime.now().toString().substring(0, 4));
  int month = int.parse(DateTime.now().toString().substring(5, 7));
  int day = int.parse(DateTime.now().toString().substring(8, 10));

  @override
  Widget build(BuildContext context) {
    print(Get.width);
    print(DateTime.now());
    return Container(
      padding: EdgeInsets.all(30),
      child: Container(
        // color: Colors.blueGrey,
        padding: EdgeInsets.symmetric(horizontal: Get.width <= 350 ? 0 : 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //       'Judul task',
            //       style: textStyle,
            //     ),
            //     SizedBox(height: 11),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         InkWell(
            //           onTap: () {
            //             sheetController.isKeseharian.value =
            //                 !sheetController.isKeseharian.value;
            //             sheetController.isProject.value =
            //                 !sheetController.isProject.value;
            //           },
            //           child: Obx(() => Container(
            //                 height: 49,
            //                 width: 118,
            //                 decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(10),
            //                     color: sheetController.isKeseharian.value
            //                         ? Color(0xffFF810C)
            //                         : Colors.white,
            //                     border: Border.all(
            //                         color: sheetController.isKeseharian.value
            //                             ? Colors.white
            //                             : Color(0xffFF810C))),
            //                 child: Center(
            //                   child: Text(
            //                     'Keseharian',
            //                     style: textStyle.copyWith(
            //                         color: sheetController.isKeseharian.value
            //                             ? Colors.white
            //                             : Color(0xffFF810C),
            //                         fontWeight: FontWeight.w500),
            //                   ),
            //                 ),
            //               )),
            //         ),
            //         InkWell(
            //           onTap: () {
            //             sheetController.isKeseharian.value =
            //                 !sheetController.isKeseharian.value;
            //             sheetController.isProject.value =
            //                 !sheetController.isProject.value;
            //           },
            //           child: Obx(() => Container(
            //                 height: 49,
            //                 width: 118,
            //                 decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(10),
            //                     color: sheetController.isProject.value
            //                         ? Color(0xffFF810C)
            //                         : Colors.white,
            //                     border: Border.all(
            //                         color: sheetController.isProject.value
            //                             ? Colors.white
            //                             : Color(0xffFF810C))),
            //                 child: Center(
            //                   child: Text(
            //                     'Project',
            //                     style: textStyle.copyWith(
            //                         color: sheetController.isProject.value
            //                             ? Colors.white
            //                             : Color(0xffFF810C),
            //                         fontWeight: FontWeight.w500),
            //                   ),
            //                 ),
            //               )),
            //         )
            //       ],
            //     )
            //   ],
            // ),
            SizedBox(height: 21),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Judul task',
                  style: textStyle,
                ),
                SizedBox(height: 11),
                Container(
                  height: 36,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xffFF810C))),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.bottom,
                    controller: sheetController.taskController,
                    decoration: InputDecoration(
                        hintText: 'Judul task',
                        hintStyle: TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                  'Deadline task',
                  style: textStyle,
                ),
                SizedBox(height: 11),
                // GestureDetector(
                //   onTap: () {
                //     DatePicker.showDatePicker(
                //       context,
                //       minTime: DateTime(year, month, day),
                //       maxTime: DateTime(year + 2),
                //       theme: DatePickerTheme(
                //           doneStyle: TextStyle(
                //               fontFamily: 'Poppins', color: Color(0xffFF810C))),
                //       onConfirm: (date) {
                //         sheetController.onDateSubmit(date.toString());
                //         print('confirm $date');
                //       },
                //     );
                //   },
                //   child: Obx(() => Container(
                //         height: 36,
                //         padding: EdgeInsets.symmetric(horizontal: 10),
                //         margin: EdgeInsets.only(bottom: 14),
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(10),
                //             border: Border.all(color: Color(0xffFF810C))),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               sheetController.dateSubmit.value,
                //               style: textStyle.copyWith(fontSize: 13),
                //             ),
                //             Icon(Icons.keyboard_arrow_down)
                //           ],
                //         ),
                //       )),
                // ),
                GestureDetector(
                  onTap: () {
                    DatePicker.showTimePicker(
                      context,
                      theme: DatePickerTheme(
                          doneStyle: TextStyle(
                              fontFamily: 'Poppins', color: Color(0xffFF810C))),
                      onConfirm: (date) {
                        sheetController.onTimeSubmit(date.toString());
                        print('time $date');
                      },
                    );
                  },
                  child: Obx(() => Container(
                        height: 36,
                        width: 100,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xffFF810C))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              sheetController.timeSubmit.value,
                              style: textStyle.copyWith(fontSize: 13),
                            ),
                            Icon(Icons.keyboard_arrow_down)
                          ],
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(height: 46),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    if (sheetController.timeSubmit.value != 'Jam' &&
                        sheetController.taskController.text != '') {
                      if (sheetController.isKeseharian.value) {
                        FirestoreService.addTask(
                          FirebaseAuth.instance.currentUser,
                          Task(
                              judul: sheetController.taskController.text,
                              tanggalDeadline: sheetController.dateSubmit.value,
                              jamDeadline: sheetController.timeSubmit.value,
                              dateTime: DateTime.now().toString()),
                          cldrController.dateNow.value,
                        );
                      }

                      sheetController.dateSubmit.value = 'Tanggal';
                      sheetController.timeSubmit.value = 'Jam';
                      sheetController.taskController.text = '';
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(500, 49),
                      primary: Color(0xffFF810C),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    'Buat',
                    style: textStyle.copyWith(fontWeight: FontWeight.w500),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

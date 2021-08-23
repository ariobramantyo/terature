import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BottomSheetController extends GetxController {
  var isKeseharian = true.obs;
  var isProject = false.obs;

  late TextEditingController taskController;

  var dateSubmit = 'Tanggal'.obs;
  var timeSubmit = 'Jam'.obs;

  void onDateSubmit(String date) {
    dateSubmit.value = date.substring(0, 10);
  }

  void onTimeSubmit(String date) {
    timeSubmit.value = date.substring(11, 16);
  }

  @override
  void onInit() {
    taskController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }
}

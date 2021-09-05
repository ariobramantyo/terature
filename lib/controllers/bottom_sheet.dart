import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BottomSheetController extends GetxController {
  late TextEditingController taskController;

  var dateSubmit = 'Tanggal'.obs;
  var timeSubmit = 'Time'.obs;

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

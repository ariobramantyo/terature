import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EditDataController extends GetxController {
  late TextEditingController editDataController;

  @override
  void onInit() {
    editDataController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    editDataController.dispose();
  }
}

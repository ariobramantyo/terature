import 'package:get/get.dart';
import 'package:terature/screen/chat.dart';
import 'package:terature/screen/dashboard.dart';
import 'package:terature/screen/profile.dart';
import 'package:terature/screen/settings.dart';

class NavBarController extends GetxController {
  var currentTab = 0.obs;
  final List screens = [
    Dashboard(),
    Chat(),
    Settings(),
    Profile(),
  ];

  void pageChange(int screen) {
    currentTab.value = screen;
  }
}

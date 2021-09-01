import 'package:get/get.dart';

class CalendarController extends GetxController {
  late CalendarController cldrController;

  var calendarDateSelected = DateTime.now();
  var dateNow = DateTime.now().toString().substring(0, 10).obs;

  void onDateSelected(DateTime date) {
    dateNow.value = date.toString().substring(0, 10);
  }

  @override
  void onInit() {
    cldrController = CalendarController();
    super.onInit();
  }

  @override
  void dispose() {
    cldrController.dispose();
    super.dispose();
  }
}

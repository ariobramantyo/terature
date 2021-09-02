import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:terature/services/firestore_service.dart';
import 'package:terature/services/notification.dart';

class NotificationController extends GetxController {
  var allowNotification = true.obs;

  @override
  void onInit() {
    firstInitialization();
    super.onInit();
  }

  void firstInitialization() {
    final box = GetStorage();

    if (box.read('allowNotification') != null) {
      if (box.read('allowNotification')) {
        allowNotification.value = true;
      } else {
        allowNotification.value = false;
      }
    } else {
      box.write('allowNotification', true);
    }
  }

  void changeNotificationStatus(User? user) {
    final box = GetStorage();

    if (allowNotification.value) {
      allowNotification.value = false;
      box.write('allowNotification', false);
      NotificationService.cancelAllNotifications();
    } else {
      allowNotification.value = true;
      box.write('allowNotification', true);
      FirestoreService.firstInitializationAfterLogin(user);
    }
  }
}

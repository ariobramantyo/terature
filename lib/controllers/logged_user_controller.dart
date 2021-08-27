import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:terature/model/task.dart';
import 'package:terature/model/user.dart';
import 'package:terature/services/firestore_service.dart';

class UserController extends GetxController {
  var loggedUser = UserData().obs;
  var userTask = List<Task>.empty().obs;

  @override
  void onInit() async {
    await FirestoreService.getUserDataFromFirebase(
        FirebaseAuth.instance.currentUser);

    print('usercontroller');

    super.onInit();
  }
}

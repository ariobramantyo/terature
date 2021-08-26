import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:terature/model/user.dart';
import 'package:terature/services/firestore_service.dart';

class UserController extends GetxController {
  var loggedUser = UserData().obs;

  @override
  void onInit() async {
    FirestoreService.getUserDataFromFirebase(FirebaseAuth.instance.currentUser);
    super.onInit();
  }
}

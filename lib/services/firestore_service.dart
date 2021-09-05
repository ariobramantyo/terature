import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:terature/controllers/logged_user_controller.dart';
import 'package:terature/model/task.dart';
import 'package:terature/model/user.dart';
import 'package:terature/services/notification.dart';

final userController = Get.find<UserController>();

class FirestoreService {
  static void addTask(User? user, Task task) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('task')
        .add(task.toMap());
  }

  static void checkTask(
      User? user, String collection, String docID, Task task) {
    print(docID);
    if (task.isDone) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .collection('task')
          .doc(docID)
          .update({'isDone': false});

      Get.snackbar('The task is back on', '${task.judul} moved to on going tab',
          colorText: Colors.white);
    } else {
      FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .collection('task')
          .doc(docID)
          .update({'isDone': true});

      Get.snackbar('Task completed', '${task.judul} moved to completed tab',
          colorText: Colors.white);
    }
  }

  static void deleteTask(User? user, String collection, String docId) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('task')
        .doc(docId)
        .delete();
  }

  static Future<void> addUserDataToFirestore(User? user,
      {UserData? userData}) async {
    final checkUser = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();

    if (checkUser.data() == null) {
      if (userData != null) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .set(userData.toMap());
      } else {
        await FirebaseFirestore.instance.collection('user').doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName,
          'email': user.email,
          'no': user.phoneNumber ?? '',
          'imageUrl': user.photoURL ?? '',
        });
      }
    }

    await getUserDataFromFirebase(user);

    // final currentUser =
    //     await FirebaseFirestore.instance.collection('user').doc(user.uid).get();

    // final currentUserData = currentUser.data() as Map<String, dynamic>;

    // userController.loggedUser.value = UserData(
    //     name: currentUserData['name'],
    //     email: currentUserData['email'],
    //     no: currentUserData['no'],
    //     imageUrl: currentUserData['imageUrl']);
  }

  static Future<void> getUserDataFromFirebase(User? user) async {
    if (user != null) {
      final currentUser = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();

      final currentUserData = currentUser.data() as Map<String, dynamic>;

      userController.loggedUser.value = UserData(
          uid: currentUserData['uid'],
          name: currentUserData['name'],
          email: currentUserData['email'],
          no: currentUserData['no'],
          imageUrl: currentUserData['imageUrl']);
    }
  }

  static Future<void> firstInitializationAfterLogin(User? user) async {
    if (user != null) {
      final taskList = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .collection('task')
          .get();

      final taskListData =
          taskList.docs.map((data) => Task.fromSnapshot(data)).toList();

      userController.userTask.addAll(taskListData);
      userController.userTask.refresh();

      print('ambil semua task user dari firestore');

      final box = GetStorage();

      if (box.read('isLoggedIn') != null) {
        if (!box.read('isLoggedIn')) {
          //cek apakah user sebelumnya log out, jika ya maka akan diset semua notifikasi berdasarkan semua task
          if (box.read('allowNotification') != null) {
            if (box.read('allowNotification')) {
              //cek apakah user mengaktifkan notifikasi atau tidak
              await NotificationService.setNotificationFromAllUsersTask(
                  userController.userTask);
            }
          } else {
            await NotificationService.setNotificationFromAllUsersTask(
                userController.userTask);
          }
        }
      }

      //menyimpan status user logged in menjadi true setelah login
      box.write('isLoggedIn', true);
    }
  }

  static Future<void> updateData(
      String uid, String newData, String type) async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .update({type: newData});
  }

  static Future<void> updateUserPhoto(String uid, String imageUrl) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .update({'imageUrl': imageUrl});
  }
}

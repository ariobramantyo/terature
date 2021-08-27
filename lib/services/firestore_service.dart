import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:terature/controllers/logged_user_controller.dart';
import 'package:terature/model/task.dart';
import 'package:terature/model/user.dart';

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

      Get.snackbar('Task kembali dikerjakan',
          'task ${task.judul} dipindahkan ke dalam tab on going',
          colorText: Colors.white);
    } else {
      FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .collection('task')
          .doc(docID)
          .update({'isDone': true});

      Get.snackbar('Task selesai',
          'task ${task.judul} dipindahkan ke dalam tab completed',
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
      print('user belum dibuat');
      if (userData != null) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .set(userData.toMap());
        print('masuk if');
      } else {
        await FirebaseFirestore.instance.collection('user').doc(user.uid).set({
          'name': user.displayName,
          'email': user.email,
          'no': user.phoneNumber ?? '',
          'imageUrl': user.photoURL ?? '',
        });
        print('masuk else');
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
          name: currentUserData['name'],
          email: currentUserData['email'],
          no: currentUserData['no'],
          imageUrl: currentUserData['imageUrl']);
    }
  }

  static Future<void> getUserTaskFromFirebase(User? user) async {
    if (user != null) {
      final taskList = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .collection('task')
          .get();

      final taskListData =
          taskList.docs.map((data) => Task.fromSnapshot(data)).toList();

      userController.userTask.value.addAll(taskListData);
      userController.userTask.refresh();
      print('usertask');
    }
  }
}

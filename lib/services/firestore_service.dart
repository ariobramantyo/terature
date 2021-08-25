import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:terature/model/task.dart';
import 'package:terature/model/user.dart';

class FirestoreService {
  static void addTask(User? user, Task task, String docId) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection(docId)
        .add(task.toMap());
  }

  static void checkTask(
      User? user, String collection, String docID, Task task) {
    if (task.isDone) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .collection(collection)
          .doc(docID)
          .update({'isDone': false});

      Get.snackbar('Task kembali dikerjakan',
          'task ${task.judul} dipindahkan ke dalam tab on going',
          colorText: Colors.white);
    } else {
      FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .collection(collection)
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
        .collection(collection)
        .doc(docId)
        .delete();
  }

  static void addUserDataToFirestore(User? user, UserData userData) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('userData')
        .where('email', isEqualTo: user.email)
        .get()
        .then((value) {
      print('masuk');
      if (!value.docs.first.exists) {
        FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .collection('userData')
            .add(userData.toMap());
      }
    });
  }
}

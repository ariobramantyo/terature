import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
    } else {
      FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .collection(collection)
          .doc(docID)
          .update({'isDone': true});
    }
  }

  static void deleteTask(User? user, String docId) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('taskHarian')
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

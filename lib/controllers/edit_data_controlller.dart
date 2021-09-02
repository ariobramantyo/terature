import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditDataController extends GetxController {
  late TextEditingController editDataController;
  late ImagePicker imagePicker;
  XFile? pickedImage;

  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  void onInit() {
    editDataController = TextEditingController();
    imagePicker = ImagePicker();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    editDataController.dispose();
  }

  Future getImageFromGallery() async {
    try {
      final checkImage =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (checkImage != null) {
        print(checkImage.name);
        print(checkImage.path);
        pickedImage = checkImage;
      }
    } catch (e) {
      print(e.toString());
      pickedImage = null;
    }
  }

  Future<String> uploadImage(String uid) async {
    EasyLoading.show(status: 'loading...');

    Reference storageRef = _firebaseStorage.ref('$uid.jpg');
    File filePath = File(pickedImage!.path);

    try {
      await storageRef.putFile(filePath);
      final photoUrl = await storageRef.getDownloadURL();

      EasyLoading.dismiss();
      return photoUrl;
    } catch (e) {
      print(e.toString());
      EasyLoading.dismiss();
      return '';
    }
  }

  Future<String> updateUserPhoto(User? user) async {
    await getImageFromGallery();

    var result = '';
    await Get.defaultDialog(
      title: 'Change Profile Picture',
      middleText: 'Are you sure want to change your profile picture?',
      barrierDismissible: false,
      onCancel: () {
        pickedImage = null;
        Get.back();
      },
      onConfirm: () async {
        result = await uploadImage(user!.uid);
        Get.back();
      },
    );

    return result;
  }
}

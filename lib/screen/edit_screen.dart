import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:terature/controllers/edit_data_controlller.dart';
import 'package:terature/services/firestore_service.dart';

class EditScreen extends StatelessWidget {
  final String type;
  final String content;

  EditScreen({Key? key, required this.type, required this.content})
      : super(key: key);

  TextStyle textStyle = TextStyle(
      fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w500);

  final editDataController = Get.find<EditDataController>();

  @override
  Widget build(BuildContext context) {
    editDataController.editDataController.text = content;
    return Scaffold(
      backgroundColor: Color(0xff151515),
      appBar: AppBar(
        title: Text(type, style: textStyle.copyWith(fontSize: 23)),
        backgroundColor: Color(0xff151515),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 40),
            Container(
              height: 50,
              child: TextField(
                textAlignVertical: TextAlignVertical.bottom,
                controller: editDataController.editDataController,
                style: textStyle.copyWith(color: Colors.white),
                keyboardType: type == 'Phone number'
                    ? TextInputType.number
                    : TextInputType.text,
                decoration: InputDecoration(
                    hintText: type,
                    hintStyle: textStyle.copyWith(color: Colors.white),
                    filled: true,
                    fillColor: Color(0xff353535),
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 60,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: () async {
                  if (editDataController.editDataController.text != '') {
                    if (type == 'Name') {
                      await FirestoreService.updateData(
                          userController.loggedUser.value.uid!,
                          editDataController.editDataController.text,
                          'name');
                      userController.loggedUser.update((user) {
                        user!.name = editDataController.editDataController.text;
                      });

                      userController.loggedUser.refresh();

                      Get.back();
                    } else {
                      if (editDataController.editDataController.text
                              .contains(',') ||
                          editDataController.editDataController.text
                              .contains('.')) {
                        Get.snackbar(
                            'Invalid input', 'phone number must be a number',
                            colorText: Colors.white);
                      } else if (editDataController
                                  .editDataController.text.length <
                              11 ||
                          editDataController.editDataController.text.length >
                              12) {
                        Get.snackbar('Invalid input',
                            'the length of the phone number must be more than 10 and less than 13',
                            colorText: Colors.white);
                      } else {
                        await FirestoreService.updateData(
                            userController.loggedUser.value.uid!,
                            editDataController.editDataController.text,
                            'no');

                        userController.loggedUser.update((user) {
                          user!.no = editDataController.editDataController.text;
                        });
                        userController.loggedUser.refresh();
                        Get.back();
                      }
                    }
                  }
                },
                child: Center(
                  child: Text(
                    'Save',
                    style: textStyle,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  primary: Color(0xffFF810C),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

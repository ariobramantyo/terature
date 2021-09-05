import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:terature/controllers/theme_controller.dart';
import 'package:terature/screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final themeController = Get.put(AppTheme());

  @override
  Widget build(BuildContext context) {
    print('BUILD MYAPP ======================================================');
    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Terature',
          darkTheme: AppTheme().darkTheme,
          theme: AppTheme().lightTheme,
          themeMode: themeController.themeMode.value,
          builder: EasyLoading.init(),
          home: SplashScreen(),
        ));
  }
}

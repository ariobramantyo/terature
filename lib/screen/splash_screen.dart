import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:terature/constant/color.dart';
import 'package:terature/controllers/theme_controller.dart';
import 'package:terature/wrapper.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final themeController = Get.find<AppTheme>();

  @override
  Widget build(BuildContext context) {
    print(
        'BUILD SPLASH ======================================================');
    return Obx(
      () => Scaffold(
        backgroundColor: themeController.isDarkMode.value
            ? AppColor.darkBackgroundColor
            : AppColor.lightPrimaryColor,
        body: Stack(
          children: [
            Positioned(
              bottom: -24,
              child: SvgPicture.asset(
                themeController.isDarkMode.value
                    ? 'assets/dark_texture_splash.svg'
                    : 'assets/light_texture_splash.svg',
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Positioned(
              top: 76,
              left: 33,
              child: Text(
                'Terature',
                style: TextStyle(
                    fontFamily: 'Quadranta',
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 224,
              child: Container(
                height: 94,
                width: 67,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFFA9A9A9),
                        blurRadius: 100,
                        spreadRadius: 1,
                        offset: Offset(1, 1))
                  ],
                  borderRadius: BorderRadius.all(Radius.elliptical(67, 94)),
                ),
              ),
            ),
            Positioned(
              left: 43,
              bottom: 179,
              child: RichText(
                  text: TextSpan(
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 23),
                      children: [
                    TextSpan(
                        text: 'Manage\nyour activity\nstart from\n',
                        style: TextStyle(
                            color: themeController.isDarkMode.value
                                ? Colors.white
                                : Colors.black)),
                    TextSpan(
                        text: 'now',
                        style: TextStyle(
                            color: AppColor.lightPrimaryColor,
                            fontWeight: FontWeight.w600)),
                  ])),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Wrapper(),
                      ));
                },
                child: Container(
                  height: 48,
                  width: 48,
                  margin: EdgeInsets.only(bottom: 50),
                  decoration: BoxDecoration(
                      color: Color(0xFFFF7A00), shape: BoxShape.circle),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 27,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

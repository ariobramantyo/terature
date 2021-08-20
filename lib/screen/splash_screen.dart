import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:terature/screen/login_screen.dart';
import 'package:terature/wrapper.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: Stack(
        children: [
          Positioned(
            bottom: -24,
            child: SvgPicture.asset(
              'assets/texture_splash.svg',
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
                  TextSpan(text: 'Aturlah\nkegiatanmu\nmulai dari\n'),
                  TextSpan(
                      text: 'sekarang',
                      style: TextStyle(
                          color: Color(0xFFFF7A00),
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
    );
  }
}

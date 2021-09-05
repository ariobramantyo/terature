import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:terature/constant/color.dart';
import 'package:terature/controllers/theme_controller.dart';
import 'package:terature/screen/sign_up_screen.dart';
import 'package:terature/services/auth_service.dart';
import 'package:terature/services/firestore_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final themeController = Get.find<AppTheme>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();

  FocusNode _emailFieldFocus = FocusNode();
  FocusNode _passwordFieldFocus = FocusNode();
  Color _emailDarkColor = AppColor.darkFormFillColor;
  Color _passwordDarkColor = AppColor.darkFormFillColor;
  Color _emailLightColor = AppColor.lightFormFillColor;
  Color _passwordLightColor = AppColor.lightFormFillColor;

  bool _obscureText = true;

  OutlineInputBorder _outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide.none);

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void initState() {
    _emailFieldFocus.addListener(() {
      if (_emailFieldFocus.hasFocus) {
        setState(() {
          _emailDarkColor = AppColor.darkFormFillFocusColor;
          _emailLightColor = AppColor.lightFormfillFocusColor;
        });
      } else {
        setState(() {
          _emailDarkColor = AppColor.darkFormFillColor;
          _emailLightColor = AppColor.lightFormFillColor;
        });
      }
    });
    _passwordFieldFocus.addListener(() {
      if (_passwordFieldFocus.hasFocus) {
        setState(() {
          _passwordDarkColor = AppColor.darkFormFillFocusColor;
          _passwordLightColor = AppColor.lightFormfillFocusColor;
        });
      } else {
        setState(() {
          _passwordDarkColor = AppColor.darkFormFillColor;
          _passwordLightColor = AppColor.lightFormFillColor;
        });
      }
    });
    super.initState();
  }

  Widget _formField(TextEditingController controller, String hint,
      FocusNode focusNode, Color color, bool obscure,
      {Widget? suffix}) {
    return Container(
      width: 256,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        focusNode: focusNode,
        obscureText: obscure,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 14),
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: color,
            focusedBorder: _outlineBorder,
            enabledBorder: _outlineBorder,
            errorBorder: _outlineBorder,
            focusedErrorBorder: _outlineBorder,
            suffixIcon: suffix),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field can\'t be empty';
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('BUILD LOGIN ======================================================');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 256,
            margin: EdgeInsets.only(top: 78, bottom: 31),
            child: Text(
              'Log In',
              style: TextStyle(
                  // color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 23,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Obx(() => Container(
                width: 256,
                height: 45,
                decoration: BoxDecoration(
                    color: themeController.isDarkMode.value
                        ? AppColor.darkThirdColor
                        : AppColor.lightSecondaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await AuthService.googleSignIn(context);
                        //     .then((value) {
                        //   var user = FirebaseAuth.instance.currentUser;
                        //   FirestoreService.addUserDataToFirestore(
                        //       FirebaseAuth.instance.currentUser,
                        //       UserData(
                        //           name: user!.displayName!,
                        //           email: user.email!,
                        //           no: user.phoneNumber!,
                        //           imageUrl: user.photoURL!));
                        // });
                        // Navigator.pop(context);
                      },
                      child: Container(
                          height: 45,
                          width: 128,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: themeController.isDarkMode.value
                                  ? AppColor.darkScondaryColor
                                  : AppColor.lightPrimaryColor,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  topLeft: Radius.circular(10))),
                          child: SvgPicture.asset(
                            'assets/google_logo.svg',
                          )),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await AuthService.facebookSignIn(context);
                        //     .then((value) {
                        //   var user = FirebaseAuth.instance.currentUser;
                        //   FirestoreService.addUserDataToFirestore(
                        //       FirebaseAuth.instance.currentUser,
                        //       UserData(
                        //           name: user!.displayName!,
                        //           email: user.email!,
                        //           no: user.phoneNumber!,
                        //           imageUrl: user.photoURL!));
                        // });
                        // Navigator.pop(context);
                      },
                      child: Container(
                          height: 45,
                          width: 128,
                          padding: EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            'assets/facebook_logo.svg',
                          )),
                    )
                  ],
                ),
              )),
          SizedBox(
            height: 53,
          ),
          Form(
              key: _key,
              child: Column(
                children: [
                  Obx(
                    () => _formField(
                        _emailController,
                        'Email',
                        _emailFieldFocus,
                        themeController.isDarkMode.value
                            ? _emailDarkColor
                            : _emailLightColor,
                        false),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Obx(
                    () => _formField(
                      _passwordController,
                      'Password',
                      _passwordFieldFocus,
                      themeController.isDarkMode.value
                          ? _passwordDarkColor
                          : _passwordLightColor,
                      _obscureText,
                      suffix: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: _obscureText
                            ? Icon(
                                Icons.visibility_off_outlined,
                                color: themeController.isDarkMode.value
                                    ? Colors.white
                                    : AppColor.lightPrimaryColor,
                                size: 18,
                              )
                            : Icon(
                                Icons.visibility_outlined,
                                color: themeController.isDarkMode.value
                                    ? Colors.white
                                    : AppColor.lightPrimaryColor,
                                size: 18,
                              ),
                      ),
                    ),
                  )
                ],
              )),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 256,
              child: Text(
                'Forgot password?',
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: Color(0xFFA7A7A7),
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (_key.currentState!.validate()) {
                try {
                  await AuthService.signIn(
                          _emailController.text, _passwordController.text)
                      .then((value) =>
                          FirestoreService.addUserDataToFirestore(value));
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'wrong-password') {
                    showDialog(
                        context: context,
                        builder: (context) => alertDialog(context,
                            'Invalid Password', 'Wrong password or email'));
                  } else if (e.code == 'invalid-email') {
                    showDialog(
                        context: context,
                        builder: (context) => alertDialog(
                            context,
                            'Invalid Email',
                            'Please try again with the correct email!'));
                  } else if (e.code == 'user-not-found') {
                    showDialog(
                        context: context,
                        builder: (context) => alertDialog(
                            context,
                            'User Not Found',
                            'Email that you use not registered yet. Try to sign up first'));
                  }
                } catch (e) {
                  print(e.toString());
                }

                print('sukses');
              }
            },
            child: Container(
              height: 36,
              width: 256,
              margin: EdgeInsets.only(top: 44, bottom: 20),
              decoration: BoxDecoration(
                  color: AppColor.lightPrimaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12.withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: 1,
                        offset: Offset(2, 5))
                  ]),
              child: Center(
                child: Text(
                  'Log in',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins'),
                ),
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Obx(
              () => Text('Dont have an account? ',
                  style: TextStyle(
                      color: themeController.isDarkMode.value
                          ? AppColor.darkThirdColor
                          : Colors.grey[800],
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w400)),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SignUpScreen();
                }));
                _emailController.text = '';
                _passwordController.text = '';
              },
              child: Text('Sign up',
                  style: TextStyle(
                      color: AppColor.lightPrimaryColor,
                      fontWeight: FontWeight.w700)),
            )
          ])
        ],
      ),
    );
  }
}

Widget alertDialog(BuildContext context, String title, String content) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    title: Text(
      title,
      style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
    ),
    content: Text(
      content,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w400),
    ),
    actions: [
      InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(10)),
              child: Text(
                'Retry',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
              )),
        ),
      )
    ],
    actionsPadding: EdgeInsets.symmetric(horizontal: 10),
  );
}

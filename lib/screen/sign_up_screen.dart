import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:terature/screen/login_screen.dart';
import 'package:terature/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _noController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  final _key = GlobalKey<FormState>();

  FocusNode _emailFieldFocus = FocusNode();
  FocusNode _passwordFieldFocus = FocusNode();
  FocusNode _noFieldFocus = FocusNode();
  FocusNode _namaFieldFocus = FocusNode();
  Color _emailColor = Color(0xFF353535);
  Color _passwordColor = Color(0xFF353535);
  Color _noColor = Color(0xFF353535);
  Color _namaColor = Color(0xFF353535);
  bool _obscureText = true;

  OutlineInputBorder _outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide.none);

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _namaController.dispose();
    _noController.dispose();
    super.dispose();
  }

  void initState() {
    _emailFieldFocus.addListener(() {
      if (_emailFieldFocus.hasFocus) {
        setState(() {
          _emailColor = Color(0xFF575757);
        });
      } else {
        setState(() {
          _emailColor = Color(0xFF353535);
        });
      }
    });
    _passwordFieldFocus.addListener(() {
      if (_passwordFieldFocus.hasFocus) {
        setState(() {
          _passwordColor = Color(0xFF575757);
        });
      } else {
        setState(() {
          _passwordColor = Color(0xFF353535);
        });
      }
    });
    _noFieldFocus.addListener(() {
      if (_noFieldFocus.hasFocus) {
        setState(() {
          _noColor = Color(0xFF575757);
        });
      } else {
        setState(() {
          _noColor = Color(0xFF353535);
        });
      }
    });
    _namaFieldFocus.addListener(() {
      if (_namaFieldFocus.hasFocus) {
        setState(() {
          _namaColor = Color(0xFF575757);
        });
      } else {
        setState(() {
          _namaColor = Color(0xFF353535);
        });
      }
    });
    super.initState();
  }

  Widget _formField(TextEditingController controller, String hint,
      FocusNode focusNode, Color color, bool obscure,
      {String? Function(String?)? validate,
      TextInputType? inputType,
      Widget? suffix}) {
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
              color: Colors.white),
          focusNode: focusNode,
          obscureText: obscure,
          keyboardType: inputType == null ? TextInputType.text : inputType,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 14),
              hintText: hint,
              hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
              filled: true,
              fillColor: color,
              focusedBorder: _outlineBorder,
              enabledBorder: _outlineBorder,
              errorBorder: _outlineBorder,
              focusedErrorBorder: _outlineBorder,
              suffixIcon: suffix),
          validator: validate == null
              ? (value) {
                  if (value!.isEmpty) {
                    return 'This field can\'t be empty';
                  }
                }
              : validate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff0F0F0F),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            margin: EdgeInsets.only(left: 19, top: 78, bottom: 34),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xFFFF7A00)),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 11,
                ),
                Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 23,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 256,
                  height: 45,
                  decoration: BoxDecoration(
                      color: Color(0xff575757),
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
                          Navigator.pop(context);
                        },
                        child: Container(
                            height: 45,
                            width: 128,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Color(0xFF262626),
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
                          Navigator.pop(context);
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
                ),
                SizedBox(
                  height: 53,
                ),
                Form(
                    key: _key,
                    child: Column(
                      children: [
                        _formField(_namaController, 'Nama', _namaFieldFocus,
                            _namaColor, false),
                        SizedBox(
                          height: 25,
                        ),
                        _formField(_emailController, 'Email', _emailFieldFocus,
                            _emailColor, false),
                        SizedBox(
                          height: 25,
                        ),
                        _formField(_noController, 'No telefon', _noFieldFocus,
                            _noColor, false, validate: (value) {
                          if (value!.isEmpty) {
                            return 'This field can\'t be empty';
                          } else if (value.length < 11) {
                            return 'Phone number minimum 11 number';
                          } else if (value.length > 12) {
                            return 'Phone number maximum 12 number';
                          }
                        }, inputType: TextInputType.number),
                        SizedBox(
                          height: 25,
                        ),
                        _formField(
                          _passwordController,
                          'Password',
                          _passwordFieldFocus,
                          _passwordColor,
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
                                    color: Colors.white,
                                    size: 18,
                                  )
                                : Icon(
                                    Icons.visibility_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 41,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_key.currentState!.validate()) {
                      try {
                        await AuthService.signUp(
                            _emailController.text, _passwordController.text);
                        // .then((value) {
                        // var user = FirebaseAuth.instance.currentUser;
                        // FirestoreService.addUserDataToFirestore(
                        //     FirebaseAuth.instance.currentUser,
                        //     UserData(
                        //       name: _namaController.text,
                        //       email: _emailController.text,
                        //       no: _noController.text,
                        //     ));
                        // });
                        // UserData userData = UserData(
                        //     name: _namaController.text,
                        //     email: _emailController.text,
                        //     no: _noController.text);
                        // FirebaseFirestore.instance
                        //     .collection('user')
                        //     .doc(FirebaseAuth.instance.currentUser!.uid)
                        //     .collection('data')
                        //     .add(userData.toMap());
                        Navigator.pop(context);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          showDialog(
                              context: context,
                              builder: (context) => alertDialog(
                                  context,
                                  'Invalid Password',
                                  'Password must contain atleast 6 character. Please try again with the correct password'));
                        } else if (e.code == 'invalid-email') {
                          showDialog(
                              context: context,
                              builder: (context) => alertDialog(
                                  context,
                                  'Invalid Email',
                                  'Please try again with the correct email! format'));
                        } else if (e.code == 'email-already-in-use') {
                          showDialog(
                              context: context,
                              builder: (context) => alertDialog(
                                  context,
                                  'Email Alredy Exists',
                                  'The email provided is already in use by an existing user. Please sign in with your registered email'));
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
                    decoration: BoxDecoration(
                        color: Color(0xFFFF7A00),
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
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 111,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

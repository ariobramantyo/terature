import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<User?> signUp(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    User? firebaseUser = userCredential.user;

    return firebaseUser;
  }

  static Future<User?> signIn(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    User? firebaseUser = userCredential.user;

    return firebaseUser;
  }

  static Future<void> signOut() async {
    await _auth.signOut();

    await _googleSignIn.signOut();
  }

  static Future<void> googleSignIn() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        UserCredential userCredential =
            await _auth.signInWithCredential(authCredential);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static Stream<User?> get firebaseUserStream => _auth.authStateChanges();
}

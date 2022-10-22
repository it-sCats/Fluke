import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;//helps to know what platform we're on
class Authentication{

  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    // TODO: Add auto login logic

    return firebaseApp;
  }

static Future<User?> signInWithGoogle({required BuildContext context})async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  if (kIsWeb) { //if we are using this auth for web some things change
    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      final UserCredential userCredential =
      await auth.signInWithPopup(
          authProvider); //On the web platform, you have to use the signInWithPopup() method on the FirebaseAuth instance.

      user = userCredential.user;
    } catch (e) {
      print(e);
    }
  } else {
    final GoogleSignIn googleSignIn = GoogleSignIn(); //object of Google Sign in
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn
        .signIn(); //رنا اوبجكت من حساب تسجيل في قوقل وحطينا فيه تسجيل الدخول

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

    try {
      final UserCredential userCredential =
      await auth.signInWithCredential(credential);
      user = userCredential.user;
      debugPrint(user?.email.toString());
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
      if (e.code == 'account-exists-with-different-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content:
            'The account already exists with a different credential',
          ),
        );
      } else if (e.code == 'invalid-credential') {
        debugPrint(e.code);
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content:
            'Error occurred while accessing credentials. Try again.',
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error occurred using Google Sign In. Try again.',
        ),
      );
    }}
  }
  return user;
}
  static Future<void> signOut({required BuildContext context}) async {

    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();//on the Web platform you do not need to call the googleSignIn.signOut() method (it would result in an error), just calling FirebaseAuth.instance.signOut() will do the job.
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
  Future<String?> signInWithFacebook() async {
    String? userID;
    final AccessToken accessToken;
    // Trigger the sign-in flow
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['public_profile', 'email', 'pages_show_list', 'pages_messaging', 'pages_manage_metadata'],
    );
    if (result.status == LoginStatus.success) {
      // you are logged
      accessToken = result.accessToken!;
   userID= accessToken.userId;
    } else {
      print(result.status);
      print(result.message);
    }
return  userID;//return userID so we can add it to google
  }

  Future<void> logOutOfFb()async{
  await FacebookAuth.instance.logOut();}
}



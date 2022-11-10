import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flukepro/errorsHandling/AuthExceptionHandler.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:multiple_result/multiple_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_options.dart'; //helps to know what platform we're on

class Authentication {


  static FirebaseOptions? get platformOptions {
    if (kIsWeb) {
      // Web
      return const FirebaseOptions(
        apiKey: 'AIzaSyAgUhHU8wSJgO5MVNy95tMT07NEjzMOfz0',
        authDomain: 'react-native-firebase-testing.firebaseapp.com',
        databaseURL: 'https://react-native-firebase-testing.firebaseio.com',
        projectId: 'react-native-firebase-testing',
        storageBucket: 'react-native-firebase-testing.appspot.com',
        messagingSenderId: '448618578101',
        appId: '1:448618578101:web:0b650370bb29e29cac3efc',
        measurementId: 'G-F79DJ0VFGS',
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
       log("Analytics Dart-only initializer doesn't work on Android, please make sure to add the config file.");
       return null;
    } else {
      // Android

      FirebaseOptions(
        apiKey: 'AIzaSyAgUhHU8wSJgO5MVNy95tMT07NEjzMOfz0',
        authDomain: 'react-native-firebase-testing.firebaseapp.com',
        databaseURL: 'https://react-native-firebase-testing.firebaseio.com',
        projectId: 'react-native-firebase-testing',
        storageBucket: 'react-native-firebase-testing.appspot.com',
        messagingSenderId: '448618578101',
        appId: '1:448618578101:web:0b650370bb29e29cac3efc',
        measurementId: 'G-F79DJ0VFGS',
      );

    }
  }



  String? _token;
  String? userID;
  final _auth = FirebaseAuth.instance;
  static late AuthStatus _status;
  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp(
      options:    DefaultFirebaseOptions.currentPlatform,
    );

    return firebaseApp;
  }

  Future<Result> _authenticate(
      String email, String password, String urlSegment) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBhVcsxMNEia_R_uCxiSIm0lH7gsu-X86k";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      var body = jsonDecode(response.body);
      print(responseData);
      _token = responseData['idToken'];
      userID = responseData['localId'];
      print('************************' + _token.toString());
      if (urlSegment == "signUp") {
        sharedPreferences.setString("token", _token.toString());
        sharedPreferences.setString("userID", userID.toString());
      }

      if (response.statusCode == 200) {
        return Success('تم التسجيل بنجاح..');
      } else {
        print(response.reasonPhrase);
        return Error(
          responseData,
        );
      }
    } catch (e) {
      return Error(e);
    }
  }

  // Future<Result> signUp(String email, String password) async { register using rest api
  //
  //   return  _authenticate(email, password, 'signUp');
  // }
  Future<Result> signUp(String email, String password) async {
    User? user;
    try {
      final userCridantial = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

user=userCridantial.user;


      if (user != null) {

        return Success(user);
      } else {
        return Error(Exception('لم يتم التسجيل'));
      }
    } on FirebaseAuthException catch (e) {
      return Error(e);
    }
  }

  // Future<Result> login(String email, String password) async {
  //   return _authenticate(email, password, 'signInWithPassword');
  // }
  Future<Result> login(String email, String password) async {
    try {
      final userCredintals = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredintals != null) {
        return Success(userCredintals.user);
      } else {
        return Error('لم يتم تسجيل الدخول.');
      }
    } on FirebaseAuthException catch (e) {
      return Error(e);
    }
  }

  // Future<Result> changePassword(String newPassword) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   print(newPassword);
  //   _token = sharedPreferences.getString("token");
  //   final url =
  //       "https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyBhVcsxMNEia_R_uCxiSIm0lH7gsu-X86k";
  //   try {
  //     final respons = await http.post(
  //       Uri.parse(url),
  //       body: json.encode(
  //         {
  //           'idToken': _token,
  //           'password': newPassword,
  //           'returnSecureToken': true,
  //         },
  //       ),
  //     );
  //     final responseData = json.decode(respons.body);
  //     print(responseData);
  //     if (respons.statusCode == 200) {
  //       return Success('تم تغيير كلمة المرور بنجاح');
  //     } else {
  //       return Error(responseData['error']);
  //     }
  //   } catch (error) {
  //     Error(throw error);
  //   }
  // }
  Future<void> changePassword(String code,String newPassword,context) async{
    try{
      _auth.confirmPasswordReset(code: code, newPassword: newPassword);

    }on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
            content: Text(
              e.message.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 13),
            )),
      );
    }
  }


  // Future<Result> deleteUser() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //
  //   _token = sharedPreferences.getString("token");
  //   final url =
  //       "https://identitytoolkit.googleapis.com/v1/accounts:delete?key=AIzaSyA32jXIyc72d2QIse1chkTjCeC__d0gPsg";
  //   try {
  //     final respons = await http.post(
  //       Uri.parse(url),
  //       body: json.encode(
  //         {
  //           'idToken': _token,
  //         },
  //       ),
  //     );
  //     final responseData = json.decode(respons.body);
  //     print(responseData);
  //     if (respons.statusCode == 200) {
  //       return Success('تم حذف المستخدم ');
  //     } else {
  //       return Error(responseData['error']);
  //     }
  //   } catch (error) {
  //     Error(throw error);
  //   }
  // }

  Future<void> deleteUser() async {

      try {
       _auth.currentUser?.delete();
      } catch (error) {
        Error(throw error);
      }
    }
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    if (kIsWeb) {
      //if we are using this auth for web some things change
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential = await auth.signInWithPopup(
            authProvider); //On the web platform, you have to use the signInWithPopup() method on the FirebaseAuth instance.

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn =
          GoogleSignIn(); //object of Google Sign in
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
        }
      }
    }
    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
        Navigator.pushNamed(context,
            '/log'); //on the Web platform you do not need to call the googleSignIn.signOut() method (it would result in an error), just calling FirebaseAuth.instance.signOut() will do the job.
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
      permissions: [
        'public_profile',
        'email',
        'pages_show_list',
        'pages_messaging',
        'pages_manage_metadata'
      ],
    );
    if (result.status == LoginStatus.success) {
      // you are logged
      accessToken = result.accessToken!;

      userID = accessToken.userId;
    } else {
      print(result.status);
      print(result.message);
    }
    return userID; //return userID so we can add it to google
  }

  Future<void> logOutOfFb() async {
    await FacebookAuth.instance.logOut();
  }

  Future<AuthStatus> resetPassword({required String email}) async {
    try {
      await _auth
          .sendPasswordResetEmail(email: email)
          .then((value) => _status = AuthStatus.successful)
          .catchError(
              (e) => _status = AuthExceptionHandler.handleAuthException(e));
    } catch (e) {
      print(
          e); //TODO do Exeption handling + send code to user is way more secure
    }
    return _status;
  }
}

import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  unknown,
}

class AuthExceptionHandler {
  static handleAuthException(FirebaseAuthException e) {
    AuthStatus status;
    switch (e.code) {
      case "invalid-email":
        status = AuthStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthStatus.wrongPassword;
        break;
      case "weak-password":
        status = AuthStatus.weakPassword;
        break;
      case "email-already-in-use":
        status = AuthStatus.emailAlreadyExists;
        break;
      default:
        status = AuthStatus.unknown;
    }
    return status;
  }
  static String generateErrorMessage(error) {
    String errorMessage;
    switch (error) {
      case AuthStatus.invalidEmail:
        errorMessage = "يبدو أن عنوان البريد كتب بشكل خاطئ ";
        break;
      case AuthStatus.weakPassword:
        errorMessage = "كلمة المرور يجب أن تكون 6 حروف على الاقل";
        break;
      case AuthStatus.wrongPassword:
        errorMessage = "عنوان البريد أو الباسورد خطأ تأكد من صحتهم";
        break;
      case AuthStatus.emailAlreadyExists:
        errorMessage =
        "هذا عنوان البريد مستعمل مسبقاً";
        break;
      default:
        errorMessage = "حصل خطأ ما الرجاء إعادة المحاولة";
    }
    return errorMessage;
  }
}
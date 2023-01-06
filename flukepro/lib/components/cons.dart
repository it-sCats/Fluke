import 'package:flutter/material.dart';

//-----------Text styling
TextStyle conOnboardingText = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.w300);

TextStyle conlabelsTxt = TextStyle(
  fontFamily: 'Cairo',
  fontSize: 14,
);
TextStyle conHeadingsStyle = TextStyle(
  fontFamily: 'Cairo',
  fontWeight: FontWeight.bold,
  fontSize: 25,
  color: conBlack,
);
TextStyle conTxtLink = TextStyle(
    color: conBlack,
    fontFamily: 'Cairo',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline);
//CTA is call to action
TextStyle conCTATxt = TextStyle(
    fontFamily: 'Cairo',
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.bold);
TextStyle conTxtFeildHint = TextStyle(
  fontFamily: 'Cairo',
  fontSize: 14,
);
TextStyle conLittelTxt12 =
    TextStyle(color: conBlack, fontFamily: 'Cairo', fontSize: 12);
//------error style for forms
TextStyle conErorTxtStyle =
    TextStyle(fontFamily: 'Cairo', fontSize: 12, color: conRed);
//======inputFeild decoration
OutlineInputBorder roundedTxtFeild = OutlineInputBorder(
    borderSide: BorderSide(width: 1, color: conBlack),
    borderRadius: BorderRadius.circular(25));
OutlineInputBorder roundedPasswordFeild = OutlineInputBorder(
    borderSide: BorderSide(width: 1, color: conBlack),
    borderRadius: BorderRadius.circular(25));
OutlineInputBorder errorBorder = OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: conRed),
    borderRadius: BorderRadius.circular(25));
//--------------------field decoration
InputDecoration conFieldDeco = InputDecoration(
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: conRed),
        borderRadius: BorderRadius.circular(25)),
    errorStyle: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: conRed),
    contentPadding: EdgeInsets.symmetric(horizontal: 25),
    hintStyle: conTxtFeildHint,
    enabledBorder: roundedTxtFeild,
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: conRed),
        borderRadius: BorderRadius.circular(25)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: conBlack),
        borderRadius: BorderRadius.circular(25)));
//--------------colors
Color conBlack = Color(0xff383838);
Color conORange = Color(0xffFF7124);
Color conRed = Color(0xffFF000D);
const primaryColor = Color(0xFFF1E6FF);
Color conBlue = Color(0xff3F72BE);

const kprimaryColor = Color.fromARGB(255, 104, 75, 123);
//---------Padding
double defaultPadding = 16.0;
//CTA Decoration
BoxDecoration conCTADecoration = BoxDecoration(
  color: conORange,
  borderRadius: BorderRadius.all(
    Radius.circular(25),
  ),
);

//Request Divider 'the divider between text in OrganizerRequest
class conRequestDivider extends StatelessWidget {
  const conRequestDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 70,
      ),
      child: new Divider(
        color: conBlack.withOpacity(.3),
        height: 4,
      ),
    );
  }
}

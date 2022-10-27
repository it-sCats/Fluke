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
    fontSize: 12,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline);
//CTA is call to action
TextStyle conCTATxt = TextStyle(
    fontFamily: 'Cairo',
    color: Colors.white,
    fontSize: 17,
    fontWeight: FontWeight.bold);
TextStyle conTxtFeildHint = TextStyle(
  fontFamily: 'Cairo',
  fontSize: 14,
);
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
//--------------colors
Color conBlack = Color(0xff383838);
Color conORange = Color(0xffFF7124);
Color conRed = Color(0xffFF000D);
//---------Padding
double defaultPadding = 16.0;

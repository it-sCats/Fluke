import 'package:flutter/material.dart';

import 'cons.dart';
//call to action buttons THE ORANGE BUTTON
class CTA extends StatelessWidget {
CTA(this.txt,this.onTap);
final String txt;
Function onTap;


  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: ()=> onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        width: 290,height: 70,
        child: Text(txt ,
          textAlign: TextAlign.center,
          style: conCTATxt,),
        decoration: BoxDecoration(color: conORange,
            borderRadius: BorderRadius.all(Radius.circular(25),),),),
    );
  }
}
//Txt feilds
class txtFeild extends StatefulWidget {
  txtFeild(this.txt,this.isPassword,this.isEmail,this.isLogin);
  final String txt;
  final bool isPassword;
  final bool isEmail;
  final bool isLogin;

  @override
  State<txtFeild> createState() => _txtFeildState();
}

class _txtFeildState extends State<txtFeild> {
  late String _password;

  double _strength = 0;

  RegExp numReg = RegExp(r".*[0-9].*");

  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  String _displayText='كلمة المرور يجب أن تكون قوية ' ;
  FocusNode toSetLabel = new FocusNode();//to set label for password it creates a var to see where is the focus


  void _checkPassword(String value) {
    _password = value.trim();

    if (_password.isEmpty) {
      setState(() {
        _strength = 0;
        _displayText = 'أدخل كلمة المرور';
      });
    } else if (_password.length < 6) {
      setState(() {
        _strength = 1 / 4;
        _displayText = 'كلمة المرور قصيرة جداً';
      });
    } else if (_password.length < 8) {
      setState(() {
        _strength = 2 / 4;
        _displayText = 'كلمة المرور مقبولة ولكن ليست قوية';
      });
    } else {
      if (!letterReg.hasMatch(_password) || !numReg.hasMatch(_password)) {
        setState(() {
          // Password length >= 8
          // But doesn't contain both letter and digit characters
          _strength = 3 / 4;
          _displayText = 'كلمة المرور قوية';
        });
      } else {
        // Password length >= 8
        // Password contains both letter and digit characters
        setState(() {
          _strength = 1;
          _displayText = 'كلمة مرورك ممتازة';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 290,
      height: 70,
      child: TextFormField(
        style: TextStyle(fontSize: 15,fontFamily: 'Cairo',color: conBlack),

focusNode: toSetLabel,
        onChanged: (value) =>!widget.isLogin? _checkPassword(value):null,
        validator: (value){  if (value == null || value.isEmpty) {
          return 'الرجاء إدخال البيانات المطلوبة';
        }
        return null;},
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          keyboardType:widget.isEmail? TextInputType.emailAddress:null,
          obscureText: widget.isPassword,

          decoration: InputDecoration(
              label: widget.isPassword&&toSetLabel.hasFocus&&!widget.isLogin?Text( _displayText,style: conTxtFeildHint,):null,

              labelStyle: conTxtFeildHint,
              hintText: widget.txt,

            errorStyle: TextStyle(fontFamily: 'Cairo',fontSize: 12,color: conRed),
              contentPadding: EdgeInsets.symmetric(horizontal: 25),


              hintStyle: conTxtFeildHint,
              enabledBorder: roundedTxtFeild,
errorBorder:OutlineInputBorder(borderSide: BorderSide(width: 2,color: conRed),borderRadius: BorderRadius.circular(25)) ,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color:widget.isPassword&&!widget.isLogin?_strength <= 1 / 4
                      ? Colors.red
                      : _strength == 2 / 4
                      ? Colors.yellow
                      : _strength == 3 / 4
                      ? Colors.blue
                      : Colors.green:conBlack) ,
                  borderRadius: BorderRadius.circular(25)))),
    );
  }
}


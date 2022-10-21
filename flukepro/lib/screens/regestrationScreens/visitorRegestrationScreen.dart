import 'package:firebase_auth/firebase_auth.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';

import '../../components/customWidgets.dart';


class VisitorRegistration extends StatefulWidget {

  @override
  State<VisitorRegistration> createState() => _VisitorRegistrationState();
}

class _VisitorRegistrationState extends State<VisitorRegistration> {
  final _visitorFormKey = GlobalKey<FormState>();
  //sign in vars
  final _auth=FirebaseAuth.instance;
  String? email;
  String? password;


  late String _password;

  double _strength = 0;

  RegExp numReg = RegExp(r".*[0-9].*");

  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  String _displayText='كلمة المرور يجب أن تكون قوية ' ;

  FocusNode toSetLabel = new FocusNode();
//to set label for password it creates a var to see where is the focus
 void  _checkPassword(String value) {
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
    return Scaffold(
      resizeToAvoidBottomInset: true,//prevents keyboard from creating the error of overflowing
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        reverse: true,
        child: Form(
          key: _visitorFormKey,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Align(alignment: Alignment.centerRight,
                child: Container(margin: EdgeInsets.only(right: 65),
                  child: Text(
                    ' سجل كـ زائر ',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: conBlack,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Container(
                      height: 55,
                      width: 51,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xff383838),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          )),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white.withOpacity(1),
                        backgroundImage: AssetImage('images/image 1.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  InkWell(
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                            color: Color(0xff3F72BE).withOpacity(.9),
                            border: Border.all(
                              color: Color(0xff383838),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10,left: 17),
                              child: Text(
                                'سجل بإستخدام قوقل',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                            Container(
                              height: 55,
                              width: 51,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Color(0xff383838),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(23),
                                  )),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white.withOpacity(1),
                                backgroundImage: AssetImage('images/google-tile 1.png'),
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(left: 55, right: 15),
                      child: new Divider(
                        color: conBlack.withOpacity(.6),
                        height: 4,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        'أو',
                        style: TextStyle(
                            fontFamily: 'Cairo', fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      )),
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 50),
                      child: new Divider(
                        color: conBlack.withOpacity(.6),
                        height: 4,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ), SizedBox(
                width: 290,
                height: 70,
                child: TextFormField(

                    style: TextStyle(fontSize: 15,fontFamily: 'Cairo',color: conBlack),


                    onChanged: (value) =>email=value,
                    validator: (value){  if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال البيانات المطلوبة';
                    }
                    return null;},
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    keyboardType:TextInputType.emailAddress,

                    decoration: InputDecoration(

                        hintText:'أدخل البريد الإكتروني',

                        errorStyle: TextStyle(fontFamily: 'Cairo',fontSize: 12,color: conRed),
                        contentPadding: EdgeInsets.symmetric(horizontal: 25),


                        hintStyle: conTxtFeildHint,
                        enabledBorder: roundedTxtFeild,
                        errorBorder:errorBorder ,
                        focusedBorder: roundedPasswordFeild)),
              ),
        SizedBox(
          width: 290,
          height: 70,
          child: TextFormField(

              style: TextStyle(fontSize: 15,fontFamily: 'Cairo',color: conBlack),

              focusNode: toSetLabel,
              onChanged: (value) { _checkPassword(value); password=value;},
              validator: (value){  if (value == null || value.isEmpty) {
                return 'الرجاء إدخال البيانات المطلوبة';
              }else if(_strength<3/4){
                return 'الرجاء إدخال كلمة مرور أقوى';
              }
              return null;},
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,

              obscureText: true,

              decoration: InputDecoration(
                  label: toSetLabel.hasFocus?Text( _displayText,style: conTxtFeildHint,):null,

                  labelStyle: conTxtFeildHint,
                  hintText: 'أدخل كلمة المرور',

                  errorStyle: TextStyle(fontFamily: 'Cairo',fontSize: 12,color: conRed),
                  contentPadding: EdgeInsets.symmetric(horizontal: 25),


                  hintStyle: conTxtFeildHint,
                  enabledBorder: roundedTxtFeild,
                  errorBorder:OutlineInputBorder(borderSide: BorderSide(width: 2,color: conRed),borderRadius: BorderRadius.circular(25)) ,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color:_strength <= 1 / 4
                          ? Colors.red
                          : _strength == 2 / 4
                          ? Colors.yellow
                          : _strength == 3 / 4
                          ? Colors.blue
                          : Colors.green) ,
                      borderRadius: BorderRadius.circular(25)))),
        ),

              SizedBox(height: 20 ,),
              CTA('تسجيل ',()async{
                // Validate returns true if the form is valid, or false otherwise.
                if (_visitorFormKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.

                  try{
                  final newUser=await _auth.createUserWithEmailAndPassword(email: email.toString(), password: password.toString());
                  if(newUser!=null){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تسجيلك بنجاح ',textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Cairo',fontSize: 13),)),
                    );
                  Navigator.pushNamed(context, '/interests');}}
                      catch(e){print(e);}
                }
              }),
              Row(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: [ InkWell(
                  onTap: (){Navigator.pushNamed(context, '/log');},
                    child: Container(
                        margin: EdgeInsets.only(right:5,top: 5),
                    child: Text('قم بتسجيل دخول',textAlign: TextAlign.right,style:conTxtLink,))), InkWell(child: Container(margin: EdgeInsets.only(right:100,top: 10),
                    child: Text(' لديك حساب؟ ',textAlign: TextAlign.right,style: TextStyle(color:conBlack,fontFamily: 'Cairo',fontSize: 12,),))),],)
            ],
          ),
        ),
      ),
    );
  }
}

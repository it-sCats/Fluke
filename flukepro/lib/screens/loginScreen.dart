import 'package:flukepro/components/cons.dart';
import 'package:flukepro/components/signInWithGoogleAndFacebookButtons.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../components/customWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/authentication.dart';

class loginScreen extends StatelessWidget {
  final _logFormKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  final _auth=FirebaseAuth.instance;
  String? Email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,//prevents keyboard from creating the error of overflowing
      backgroundColor: Colors.white,
      body: Form(
        key: _logFormKey,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 8,
            ),
            Align(alignment: Alignment.centerRight,
              child: Container(margin: EdgeInsets.only(right: 65),
                child: Text(
                  'تسجيل دخول ',
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
            FutureBuilder(future: Authentication.initializeFirebase(),builder: (context,snapshot){
              if(snapshot.hasError){
                return Text('Error initializing Firebase');
              }else if(snapshot.connectionState==ConnectionState.done){
                return GoogleAndFacebookButtons();
              }return CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(conORange),);
            })
           , SizedBox(
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
            ),
            SizedBox(
              width: 290,
              height: 70,
              child: TextFormField(

                  style: TextStyle(fontSize: 15,fontFamily: 'Cairo',color: conBlack),


                  onChanged: (value) =>Email=value,
                  validator: (value){  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال البيانات المطلوبة';
                  }
                  return null;},
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  keyboardType:TextInputType.emailAddress,

                  decoration: InputDecoration(

                      hintText:'إسم المستخدم أو البريد الإكتروني',

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
                  onChanged: (value) =>password=value,
                  validator: (value){  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال البيانات المطلوبة';
                  }
                  return null;},
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText:'كلمة المرور',
                      errorStyle: TextStyle(fontFamily: 'Cairo',fontSize: 12,color: conRed),
                      contentPadding: EdgeInsets.symmetric(horizontal: 25),
                      hintStyle: conTxtFeildHint,
                      enabledBorder: roundedTxtFeild,
                      errorBorder:errorBorder ,
                      focusedBorder: roundedPasswordFeild)),
            )
            ,//custom widgets take the text and if its password or not

            Align(alignment: Alignment.centerRight,child: InkWell(child: Container(margin: EdgeInsets.only(right:75,top: 5),
                child: Text('نسيت كلمة المرور؟',textAlign: TextAlign.right,style: conTxtLink,)))),
          SizedBox(height: 21 ,),
            CTA('تسجيل دخول',()async{ if (_logFormKey.currentState!.validate()) {
              // If the form is valid, display a snackbar. In the real world,
              // you'd often call a server or save the information in a database.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري تسجيل الدخول..',style: TextStyle(fontSize: 12,fontFamily: 'Cairo',),)),

              );
              try{
          final user = await _auth.signInWithEmailAndPassword(email: Email.toString(), password: password.toString());
            if(user!= null){
              Navigator.pushNamed(context, '/home');

            }
              }
              on FirebaseAuthException catch  (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text(e.message.toString(),style: TextStyle(fontSize: 12,fontFamily: 'Cairo',),)),

                );
                print('Failed with error code: ${e.code}');
                print(e.message);
              }
            }}),
            Row(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [ InkWell(onTap:(){ Navigator.pushNamed(context, '/UserType');},child: Container(margin: EdgeInsets.only(right:5,top: 5),
                child: Text('سجل كـجهة منظمة أو\n زائر أو مشارك ',textAlign: TextAlign.right,style:conTxtLink,))), InkWell(child: Container(margin: EdgeInsets.only(right:75,top: 10),
                child: Text('ليس لديك حساب؟ ',textAlign: TextAlign.right,style: TextStyle(color:conBlack,fontFamily: 'Cairo',fontSize: 12,),))),],)
          ],
        ),
      ),
    );
  }
}

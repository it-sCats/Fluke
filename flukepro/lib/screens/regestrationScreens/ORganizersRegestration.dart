import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../components/customWidgets.dart';

class organizersRegistrationScreen extends StatefulWidget {
  @override
  State<organizersRegistrationScreen> createState() =>
      _organizersRegistrationScreenState();
}

class _organizersRegistrationScreenState
    extends State<organizersRegistrationScreen> {
  final _particapantFormKey = GlobalKey<FormState>();
  final _firestore=FirebaseFirestore.instance;

  List<String> items = [
    'معارض ',
    'ورش عمل ',
    'مؤتمرات',
    'محاضرات',
    'جلسات حوارية ',
    'جميع أنواع الاحداث'
  ];

  String? selectedItem;
  String? phoneNum;
  String? email;
  String? OrganizerName;
  String? EIN;//employer identification numbers,
String? eventType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, //prevents keyboard from creating the error of overflowing
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        reverse: true,
        child: Form(
          key:
              _particapantFormKey, //this key to unique each form so when we validate it does the work
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(right: 70),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'سجل كـجهة منظمة',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: conBlack,
                        ),
                      ),
                      Text(
                        'سجل معلومات شركتك ستتم مراجعتها\n والإجابة على طلبك عن طريق الإيميل',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: conBlack,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),

              txtFeild('إسم المشارك أو الجهة', false, false, false),
              txtFeild('example@mail.com', false, true,
                  false), //custom widgets take the text and if its password or not
              SizedBox(
                width: 290,
                height: 70,
                child: TextFormField(
                    style: TextStyle(fontSize: 15, fontFamily: 'Cairo', color: conBlack),

                    onChanged: (value) {phoneNum=value;},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البيانات المطلوبة';
                      }
                      return null;
                    },
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    keyboardType:TextInputType. number,

                    decoration: InputDecoration(

                        labelStyle: conTxtFeildHint,
                        hintText:'رقم التعريف الوظيفي',
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: conRed),
                            borderRadius: BorderRadius.circular(25)),
                        errorStyle:
                        TextStyle(fontFamily: 'Cairo', fontSize: 12, color: conRed),
                        contentPadding: EdgeInsets.symmetric(horizontal: 25),
                        hintStyle: conTxtFeildHint,
                        enabledBorder: roundedTxtFeild,
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: conRed),
                            borderRadius: BorderRadius.circular(25)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: conBlack),
                            borderRadius: BorderRadius.circular(25)))),
              ),
        SizedBox(
          width: 290,
          height: 70,
          child: TextFormField(
              style: TextStyle(fontSize: 15, fontFamily: 'Cairo', color: conBlack),

              onChanged: (value) {phoneNum=value;},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال البيانات المطلوبة';
                }
                return null;
              },
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              keyboardType:TextInputType.phone,

              decoration: InputDecoration(

                  labelStyle: conTxtFeildHint,
                  hintText:'رقم الهاتف',
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: conRed),
                      borderRadius: BorderRadius.circular(25)),
                  errorStyle:
                  TextStyle(fontFamily: 'Cairo', fontSize: 12, color: conRed),
                  contentPadding: EdgeInsets.symmetric(horizontal: 25),
                  hintStyle: conTxtFeildHint,
                  enabledBorder: roundedTxtFeild,
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: conRed),
                      borderRadius: BorderRadius.circular(25)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: conBlack),
                      borderRadius: BorderRadius.circular(25)))),
        ),
              SizedBox(
                width: 290,
                height: 70,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: DropdownButtonFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                      focusColor: Colors.white,
                      dropdownColor: Colors.white,
                      elevation: 8,

                      decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                        color: conBlack,
                      ),
                      borderRadius: BorderRadius.circular(25)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: conBlack,
                              ),
                              borderRadius: BorderRadius.circular(25)),
                          // focusedErrorBorder:OutlineInputBorder(
                          // borderSide: BorderSide(width: 2, color: conRed),
                          // borderRadius: BorderRadius.circular(25)) ,
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: conRed),
                            borderRadius: BorderRadius.circular(25)),

                          focusColor: Colors.white,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: conBlack,
                              ),
                              borderRadius: BorderRadius.circular(25))),
                      hint: Text(
                        'مانوع الاحداث التي تقوم بتنظيمها',
                        style: conTxtFeildHint,
                      ),
                      items: items
                          .map((item) => DropdownMenuItem<String>(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                      fontFamily: 'Cairo', fontSize: 13),
                                ),
                                value: item,
                              ))
                          .toList(),
                      onChanged: (item) => setState(() {
                            selectedItem = item.toString();
                          })),
                ),
              ),

              SizedBox(
                height: 20,
              ),
              CTA('تسجيل ', () {
                if (_particapantFormKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),

                  );
                  _firestore.collection('requests').add({'name':OrganizerName,'email':email,'phone':phoneNum,'EIN':EIN});
                }
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/log');
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 5, top: 5),
                          child: Text(
                            'قم بتسجيل دخول',
                            textAlign: TextAlign.right,
                            style: conTxtLink,
                          ))),
                  InkWell(
                      child: Container(
                          margin: EdgeInsets.only(right: 100, top: 10),
                          child: Text(
                            ' لديك حساب؟ ',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: conBlack,
                              fontFamily: 'Cairo',
                              fontSize: 12,
                            ),
                          ))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

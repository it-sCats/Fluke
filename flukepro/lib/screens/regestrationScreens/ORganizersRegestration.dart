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
  final _firestore = FirebaseFirestore.instance;

  List<String> typeOfevents = [
    'معارض ',
    'ورش عمل ',
    'مؤتمرات',
    'جلسات',
    'جلسات حوارية ',
    'جميع أنواع الاحداث'
  ];
  List<String> yesOrNo = [
    'نعم قمنا بتنظيم عدة أحداث ',
    'لازلنا في بداية الطريق',
    'لا لم نقم بتنظيم أي أحداث حتى الآن',
  ];

  String? selectedEventType;

  String? phoneNum;
  String? email;
  String? OrganizerName;
  String? breif; //employer identification numbers,
  String? eventType;
  bool agreeOnterms = false;
  Color borderLabelColor = conBlack;
  String? errorMessage = 'مشكلة في الباس';

  bool LogInError = false;

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
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'سجل كـجهة منظمة',
                      textAlign: TextAlign.center,
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
              SizedBox(
                height: 30,
              ),

              SizedBox(
                width: 290,
                height: 70,
                child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(
                        fontSize: 15, fontFamily: 'Cairo', color: conBlack),
                    onChanged: (value) => OrganizerName = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البيانات المطلوبة';
                      } else
                        return null;
                    },
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        labelStyle: conTxtFeildHint,
                        hintText: ''
                            'إسم الجهة أو المنظم',
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: conRed),
                            borderRadius: BorderRadius.circular(25)),
                        errorStyle: conErorTxtStyle,
                        contentPadding: EdgeInsets.symmetric(horizontal: 25),
                        hintStyle: conTxtFeildHint,
                        enabledBorder: roundedTxtFeild,
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: conRed),
                            borderRadius: BorderRadius.circular(25)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: conBlack),
                            borderRadius: BorderRadius.circular(25)))),
              ),

              SizedBox(
                width: 290,
                height: 70,
                child: TextFormField(
                    style: TextStyle(
                        fontSize: 15, fontFamily: 'Cairo', color: conBlack),
                    onChanged: (value) => email = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البيانات المطلوبة';
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(email.toString())) {
                        return 'تأكد من صحة كتابة الايميل المدخل';
                      }
                      return null;
                    },
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelStyle: conTxtFeildHint,
                        hintText: 'company@Email.com',
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: conRed),
                            borderRadius: BorderRadius.circular(25)),
                        errorStyle: conErorTxtStyle,
                        contentPadding: EdgeInsets.symmetric(horizontal: 25),
                        hintStyle: conTxtFeildHint,
                        enabledBorder: roundedTxtFeild,
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: conRed),
                            borderRadius: BorderRadius.circular(25)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: conBlack),
                            borderRadius: BorderRadius.circular(25)))),
              ), //custom widgets take the text and if its password or not
              SizedBox(
                width: 290,
                height: 70,
                child: TextFormField(
                    style: TextStyle(
                        fontSize: 15, fontFamily: 'Cairo', color: conBlack),
                    onChanged: (value) {
                      phoneNum = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البيانات المطلوبة';
                      } else {
                        if (phoneNum!.trim().length < 10) {
                          return 'رقم الهاتف يتكون من عشرة ارقام';
                        }
                      }
                      return null;
                    },
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelStyle: conTxtFeildHint,
                        hintText: 'رقم الهاتف',
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: conRed),
                            borderRadius: BorderRadius.circular(25)),
                        errorStyle: TextStyle(
                            fontFamily: 'Cairo', fontSize: 12, color: conRed),
                        contentPadding: EdgeInsets.symmetric(horizontal: 25),
                        hintStyle: conTxtFeildHint,
                        enabledBorder: roundedTxtFeild,
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: conRed),
                            borderRadius: BorderRadius.circular(25)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: conBlack),
                            borderRadius: BorderRadius.circular(25)))),
              ),

              SizedBox(
                width: 290,
                height: 80,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: DropdownButtonFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      focusColor: Colors.white,
                      dropdownColor: Colors.white,
                      elevation: 8,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
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
                      items: typeOfevents
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
                            selectedEventType = item.toString();
                          })),
                ),
              ),
              SizedBox(
                width: 290,
                height: 70,
                child: TextFormField(
                    maxLines: 5,
                    style: TextStyle(
                        fontSize: 15, fontFamily: 'Cairo', color: conBlack),
                    onChanged: (value) {
                      breif = value;
                    },
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                        labelStyle: conTxtFeildHint,
                        hintText: 'أرفق نبذة عنك كمنظم أو كشركة؟ ',
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: conRed),
                            borderRadius: BorderRadius.circular(25)),
                        errorStyle: TextStyle(
                            fontFamily: 'Cairo', fontSize: 11, color: conRed),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        hintStyle: conTxtFeildHint,
                        enabledBorder: roundedTxtFeild,
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: conRed),
                            borderRadius: BorderRadius.circular(25)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: conBlack),
                            borderRadius: BorderRadius.circular(25)))),
              ),
              SizedBox(
                height: 8,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                            side: BorderSide(color: conRed)),
                        value: agreeOnterms,
                        onChanged: (v) {
                          setState(() {
                            agreeOnterms = !agreeOnterms;
                          });
                        }),
                    Text(
                      'أوافق على شروط التسجيل وإستخدام البيانات',
                      textAlign: TextAlign.right,
                      style: conLittelTxt12.copyWith(
                          fontSize: 11, color: borderLabelColor),
                    ),
                  ],
                ),
              ),
              CTA(
                  txt: 'تسجيل ',
                  isFullwidth: true,
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_particapantFormKey.currentState!.validate()) {
                      if (agreeOnterms) {
                        // If the form is valid, display a snackbar. In the real world,

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('سيصلك إيميل يؤكد إنضمامك')),
                        );
                        final d = await _firestore.collection('requests').add({
                          'name': OrganizerName,
                          'email': email,
                          'phone': phoneNum,
                          'brief': breif,
                          'eventsType': selectedEventType,
                          'status': "waiting"
                        });
                        if (d != null) {
                          Navigator.pushNamed(context, '/log');
                        }
                      } else {
                        setState(() {
                          borderLabelColor = conRed;
                        });
                      }
                    }
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                            textAlign: TextAlign.center,
                            style: conTxtLink,
                          ))),
                  InkWell(
                      child: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            ' لديك حساب؟ ',
                            textAlign: TextAlign.center,
                            style: conLittelTxt12,
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

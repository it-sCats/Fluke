import 'package:firebase_auth/firebase_auth.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? _userType;
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String? ErrorMessage;
bool isErrored = false;
User? user = _auth.currentUser;
late Future<QueryDocumentSnapshot?> UserInfo;
final _userInfoFormKey = GlobalKey<FormState>();

class userInfoScreen extends StatefulWidget {
  @override
  State<userInfoScreen> createState() => _userInfoScreenState();
}

class _userInfoScreenState extends State<userInfoScreen> {
  @override
  void initState() {
    super.initState();
    _birthDatecon.addListener(() {
      enabled = true;
    });
    _gendercon.addListener(() {
      enabled = true;
    });
    _Phonecon.addListener(() {
      enabled = true;
    });
    getUserData();
  }

  final TextEditingController _birthDatecon = TextEditingController();
  final TextEditingController _Emailcon = TextEditingController();
  final TextEditingController _Phonecon = TextEditingController();
  final TextEditingController _gendercon = TextEditingController();
  DocumentSnapshot? data;
  String? dateinput;
  SharedPreferences? userTypeShared;

  bool enabled = false;

  //الدالة الي تجيب من الداتا بيز
  Future<DocumentSnapshot<Object?>>? getUserData() async {
    userTypeShared = await SharedPreferences.getInstance();
    _userType = userTypeShared?.getString("userType");

    return await _firestore.collection('users').doc(user!.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
          ),
          color: conBlack,
        ),
        actions: [],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: FutureBuilder<DocumentSnapshot>(
              future: getUserData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> userInfo =
                      snapshot.data!.data() as Map<String, dynamic>;
                  _Emailcon.text = userInfo['email'];
                  return Form(
                    key: _userInfoFormKey,
                    child: Column(
                      children: [
                        Text(
                          'معلوماتك الشخصية',
                          textAlign: TextAlign.center,
                          style: conHeadingsStyle.copyWith(fontSize: 18),
                        ),
                        Text(
                          'أكتب معلوماتك الشخصية, حتى إذا كان\n حساب شركة لن يتم عرض هذه المعلومات\n في ملفك العام ',
                          style: conLittelTxt12,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        txtFeild(_Emailcon.text, false, true, (value) {
                          _Emailcon.text = value;
                        }, () {}, false, Icon(Icons.edit), false, _Emailcon),
                        txtFeild(
                            userInfo['name'] == null
                                ? 'أدخل إسمك'
                                : userInfo['name'],
                            false,
                            false, (value) {
                          _gendercon.text = value;
                        }, () {}, false, Icon(Icons.edit), false, _gendercon),
                        txtFeild(
                            userInfo['phone'] == null
                                ? 'دخل رقم هاتفك'
                                : userInfo['phone'],
                            false,
                            false, (value) {
                          _Phonecon.text = value;
                        }, () {}, false, Icon(Icons.edit), false, _Phonecon),
                        txtFeild(
                            userInfo['birthDate'] == null
                                ? 'تاريخ الميلاد'
                                : userInfo['birthDate'],
                            false,
                            false,
                            () {}, () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2010),
                              firstDate: DateTime(
                                  1910), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2010));

                          if (pickedDate != null) {
                            if (pickedDate.isBefore(DateTime(2011))) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                _birthDatecon.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {
                              setState(() {
                                ErrorMessage = 'لايمكن التسجيل لأقل من 13 سنة ';
                                isErrored = !isErrored;
                              });
                            }
                          } else {
                            print("Date is not selected");
                          }
                        }, true, Icon(Icons.calendar_month_rounded), true,
                            _birthDatecon),
                        Visibility(
                          visible: isErrored, //the Error Text
                          child: Text(
                            ErrorMessage.toString(),
                            style: conErorTxtStyle,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CancleButton(
                              txt: 'لغاء التغيرات',
                              ontap: () {
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 10,
                            ),
                            Opacity(
                              opacity: enabled ? 1 : 0.5,
                              child: CTA(
                                txt: 'حفظ التغيرات',
                                isFullwidth: false,
                                onTap: () {
                                  if (_birthDatecon.text == null &&
                                      _gendercon.text == null &&
                                      _Phonecon.text == null &&
                                      _Emailcon.text == null) {}

                                  print(userInfo['name']);
                                  if (_Phonecon.text.length < 10) {
                                    setState(() {
                                      ErrorMessage =
                                          'رقم الهاتف لا يجب أن يقل عن 10 خانات';
                                      isErrored = !isErrored;
                                    });
                                  } else {
                                    _firestore
                                        .collection('users')
                                        .doc(user!.uid)
                                        .set({
                                      'email': _Emailcon.text == ''
                                          ? userInfo['email']
                                          : _Emailcon
                                              .text, //ي حال لم تتغير قيمة الايميل ابقى على القيمة السابقة وفي حال تغير نعطي القيمة الجديدة
                                      'name': _gendercon.text == ''
                                          ? userInfo['name']
                                          : _gendercon.text,
                                      'phone': _Phonecon.text,
                                      'birthDate': _birthDatecon.text
                                    }).then((value) {
                                      Navigator.pop(context);
                                    }, onError: (error) {
                                      setState(() {
                                        ErrorMessage = error.toString();
                                        isErrored = !isErrored;
                                      });
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }

                return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}

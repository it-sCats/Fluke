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

class userInfoScreen extends StatefulWidget {
  @override
  State<userInfoScreen> createState() => _userInfoScreenState();
}

class _userInfoScreenState extends State<userInfoScreen> {
  @override
  void initState() {
    // TODO: implement initState
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

  final currentVisitorRef = _firestore
      .collection('users')
      .doc('visitors')
      .collection('visitor')
      .doc(user!.uid);
  final currentPartsRef = _firestore
      .collection('users')
      .doc('paticipants')
      .collection('paticipant')
      .doc(user!.uid);
  final currentOrganisRef = _firestore
      .collection('users')
      .doc('organizingAgens')
      .collection('organizingAgen')
      .doc(user?.uid);

  bool enabled = false;
  Future<DocumentSnapshot<Object?>>? getUserData() async {
    userTypeShared = await SharedPreferences.getInstance();
    _userType = userTypeShared?.getString("userType");

    if (_userType == '0') {
      return await currentVisitorRef.get();
    } else if (_userType == '2') {
      return currentPartsRef.get();
    } else if (_userType == '1') {
      return currentOrganisRef.get();
    } else {
      return await currentVisitorRef.get();
    }
  }

  @override
  Widget build(BuildContext context) {
    var ref = currentVisitorRef;
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
                  return Column(
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
                            initialDate: DateTime.now(),
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
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
                              Navigator.pushNamed(context, '/home');
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

                                _userType == '0'
                                    ? ref = currentVisitorRef
                                    : _userType == '2'
                                        ? ref = currentPartsRef
                                        : ref = currentOrganisRef;
                                ref.set({
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
                                  Navigator.pushNamed(context, '/home');
                                }, onError: (error) {
                                  setState(() {
                                    ErrorMessage = error.toString();
                                    isErrored = !isErrored;
                                  });
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    ], //TODO implement updating the database
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

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'cons.dart';

final _firestore = FirebaseFirestore.instance;

class creatingEvent extends StatefulWidget {
  @override
  State<creatingEvent> createState() => _creatingEventState();
}

class _creatingEventState extends State<creatingEvent> {
  final eventRef = _firestore.collection('events');
  final _eventFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  var eventTypes = [
    'ورشة عمل',
    'معرض',
    'محاضرة',
    'ملتقى',
    'إجتماع',
  ];
  var fields = [
    'تقنية وتكنولوجيا',
    'زراعة',
    'دعاية وإعلام',
    'قانون وسياسة ',
    'علوم وأحياء',
  ];
  var cities = [
    'طرابلس',
    'بنغازي',
    'مصراتة',
    'الخمس',
    'سبها',
  ];
  TextEditingController _eventNameCont = TextEditingController();
  TextEditingController _eventTypeCont = TextEditingController();
  TextEditingController endDate = TextEditingController();
  Timestamp starterDate = Timestamp(1, 0);
  TextEditingController starterTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController _eventFieldCont = TextEditingController();
  TextEditingController _eventDescriptionCont = TextEditingController();
  TextEditingController _eventLocationCont = TextEditingController();
  TextEditingController _eventCityCont = TextEditingController();
  TextEditingController _targetedAudienceCont = TextEditingController();

  List<TextEditingController> _controllers = [];
  List<String> _controllersText = [];
  List<TextField> _fields = [];
  Widget _addTile() {
    return Container(
      decoration: BoxDecoration(
          color: conORange,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      width: 180,
      child: ListTile(
        title: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
        onTap: () {
          final controller = TextEditingController();
          final field = TextField(
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                hintText: "القاعة ${_controllers.length + 1}",
                hintStyle: conTxtFeildHint,
                filled: true,
                fillColor: Color(0xffF1F1F1),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10))),
          );

          setState(() {
            _controllers.add(controller);
            _fields.add(field);
          });
        },
      ),
    );
  }

  Widget roomsFields() {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: _fields.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(10),
            child: _fields[index],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool acceptsParticipants = false;
  bool sendNotifications = false;
  File? image;
  String? imagePath;
  String emptyImage = 'images/emptyIamge.jpg';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50),
      decoration: BoxDecoration(color: Colors.white60),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                onPressed: () {
                  showDialog(
                      //save to drafts dialog
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'هل ترغب في حفظ المعلومات التي أدخلتها؟ ',
                            textAlign: TextAlign.center,
                            style: conHeadingsStyle.copyWith(fontSize: 15),
                          ),
                          content: Text(
                            'يمكنك حفظ المعلومات المدخلة والعودة لها في وقت لاحق',
                            textAlign: TextAlign.center,
                            style: conHeadingsStyle.copyWith(
                                fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                          actions: [
                            InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, 'OHome');
                                },
                                child: Text(
                                  'تجاهل التغيرات',
                                  textAlign: TextAlign.center,
                                  style: conHeadingsStyle.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                )),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: conORange,
                                  borderRadius: BorderRadius.circular(10)),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'حفظ الحدث',
                                    textAlign: TextAlign.center,
                                    style: conHeadingsStyle.copyWith(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ],
                          buttonPadding: EdgeInsets.all(20),
                          actionsAlignment: MainAxisAlignment.spaceAround,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 100),
                        );
                      });
                  // Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  size: 40,
                )),
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 400,
                  child: image == null
                      ? Image.asset(emptyImage)
                      : Image.file(image!),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xffd9d9d9),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    height: 50,
                    width: 150,
                    child: InkWell(
                        onTap: () async {
                          final ImagePicker _picker = ImagePicker();
                          // Pick an image
                          final imageFile = await _picker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            imagePath = imageFile!.path;
                            image = File(imageFile!.path);
                          });

                          // Capture a photo
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera, size: 25),
                            Text(
                              'تغيير الصورة ',
                              style: conTxtFeildHint,
                            ),
                          ],
                        )),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.all(20),
              color: Colors.white,
              child: Form(
                key: _eventFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 8),
                      child: Text(
                        'إنشاء حدث:',
                        textAlign: TextAlign.right,
                        style: conHeadingsStyle.copyWith(fontSize: 20),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _eventNameCont,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            hintText: 'إسم الحدث',
                            hintStyle: conTxtFeildHint,
                            filled: true,
                            fillColor: Color(0xffF1F1F1),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              hintText: 'نوع الحدث',
                              hintStyle: conTxtFeildHint,
                              filled: true,
                              fillColor: Color(0xffF1F1F1),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10))),
                          style: conTxtFeildHint.copyWith(color: conBlack),
                          items: eventTypes.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                  items), //درنا تحويل من ليستا عادية لليستا يقبلها الدروب داون
                            );
                          }).toList(),
                          onChanged: (value) {
                            _eventTypeCont.text = value.toString();
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 8),
                      child: Text(
                        'تاريخ الحدث:',
                        textAlign: TextAlign.right,
                        style: conHeadingsStyle.copyWith(fontSize: 20),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: endDate,
                              onTap: () async {
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
                                      intl.DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                  //you can implement different kind of Date Format here according to your requirement

                                  setState(() {
                                    endDate.text = formattedDate
                                        .toString(); //set output date to TextField value.
                                  });
                                }
                              },
                              readOnly: true,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  hintText: 'إلى',
                                  hintStyle: conTxtFeildHint,
                                  filled: true,
                                  fillColor: Color(0xffF1F1F1),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: 24,
                            )),
                        Expanded(
                            flex: 3,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: InkWell(
                                child: TextFormField(
                                  onTap: () async {
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
                                          intl.DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                      print(
                                          formattedDate); //formatted date output using intl package =>  2021-03-16
                                      //you can implement different kind of Date Format here according to your requirement

                                      setState(() {
                                        starterDate = Timestamp.fromDate(
                                            pickedDate); //set output date to TextField value.
                                      });
                                    }
                                  },
                                  readOnly: true,
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      hintText: 'من',
                                      hintStyle: conTxtFeildHint,
                                      filled: true,
                                      fillColor: Color(0xffF1F1F1),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                            ))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 8),
                      child: Text(
                        'وقت الحدث:',
                        textAlign: TextAlign.right,
                        style: conHeadingsStyle.copyWith(fontSize: 20),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: endTime,
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(hour: 12, minute: 00),
                                );
                                //formatted date output using intl package =>  2021-03-16
                                //you can implement different kind of Date Format here according to your requirement

                                setState(() {
                                  endTime.text = pickedTime!.hour
                                      .toString(); //set output date to TextField value.
                                });
                              },
                              readOnly: true,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  hintText: 'إلى',
                                  hintStyle: conTxtFeildHint,
                                  filled: true,
                                  fillColor: Color(0xffF1F1F1),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: 24,
                            )),
                        Expanded(
                            flex: 3,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: InkWell(
                                child: TextFormField(
                                  controller: starterTime,
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime:
                                          TimeOfDay(hour: 12, minute: 00),
                                    );

                                    //formatted date output using intl package =>  2021-03-16
                                    //you can implement different kind of Date Format here according to your requirement

                                    setState(() {
                                      starterTime.text = pickedTime!.hour
                                          .toString(); //set output date to TextField value.
                                    });
                                  },
                                  readOnly: true,
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      hintText: 'من',
                                      hintStyle: conTxtFeildHint,
                                      filled: true,
                                      fillColor: Color(0xffF1F1F1),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                            ))
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              hintText: 'المدينة المقام فيها الحدث',
                              hintStyle: conTxtFeildHint,
                              filled: true,
                              fillColor: Color(0xffF1F1F1),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10))),
                          style: conTxtFeildHint.copyWith(color: conBlack),
                          items: cities.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                  items), //درنا تحويل من ليستا عادية لليستا يقبلها الدروب داون
                            );
                          }).toList(),
                          onChanged: (value) {
                            _eventCityCont.text = value.toString();
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _eventLocationCont,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            hintText: 'رابط مكان الحدث على قوقل مابل',
                            hintStyle: conTxtFeildHint,
                            filled: true,
                            fillColor: Color(0xffF1F1F1),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              hintText: 'المجال',
                              hintStyle: conTxtFeildHint,
                              filled: true,
                              fillColor: Color(0xffF1F1F1),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10))),
                          style: conTxtFeildHint.copyWith(color: conBlack),
                          items: fields.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                  items), //درنا تحويل من ليستا عادية لليستا يقبلها الدروب داون
                            );
                          }).toList(),
                          onChanged: (value) {
                            _eventFieldCont.text = value.toString();
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _eventDescriptionCont,
                        maxLines: 10,
                        maxLength: 3000,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            hintText:
                                'وصف عن الحدث\n ما الهدف منه وماهي الانشطة التي سيحويها\n ..وما المشاكل التي سيعالجها',
                            hintStyle: conTxtFeildHint,
                            filled: true,
                            fillColor: Color(0xffF1F1F1),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'مكان إقامة الحدث:',
                            textAlign: TextAlign.right,
                            style: conHeadingsStyle.copyWith(fontSize: 20),
                            textDirection: TextDirection.rtl,
                          ),
                          Text(
                            'حدد  القاعات أو المساحات او المباني التي ستقام \nفيها الجلسات في حال وجود عدة أماكن.',
                            textAlign: TextAlign.right,
                            style: conHeadingsStyle.copyWith(
                                fontSize: 13, fontWeight: FontWeight.normal),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        _addTile(),
                        Container(width: 200, child: roomsFields()),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Switch(
                                  value: acceptsParticipants,
                                  onChanged: (value) {
                                    setState(() {
                                      acceptsParticipants = value;
                                    });
                                  })),
                        ),
                        Expanded(
                            flex: 5,
                            child: Text(
                              'استقبال طلبات مشاركة',
                              textAlign: TextAlign.right,
                              style: conHeadingsStyle.copyWith(fontSize: 20),
                              textDirection: TextDirection.rtl,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Switch(
                                  value: sendNotifications,
                                  onChanged: (value) {
                                    setState(() {
                                      sendNotifications = value;
                                    });
                                  })),
                        ),
                        Expanded(
                            flex: 5,
                            child: Text(
                              'إشعار الفئة المستهدفة',
                              textAlign: TextAlign.right,
                              style: conHeadingsStyle.copyWith(fontSize: 20),
                              textDirection: TextDirection.rtl,
                            )),
                      ],
                    ),
                    Visibility(
                        visible: sendNotifications,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            textDirection: TextDirection.rtl,
                            controller: _targetedAudienceCont,
                            maxLines: 3,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                hintText:
                                    'مجال الفئة المستهدفة, إفصل بين كل كلمة تعبر\n عن مجالات الفئة المستهدفة بفاصلة ',
                                hintStyle: conTxtFeildHint,
                                filled: true,
                                fillColor: Color(0xffF1F1F1),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Text(
                            'حفظ كمسودة',
                            style: conTxtFeildHint.copyWith(
                                color: Colors.blueGrey, fontSize: 18),
                          ),
                          onTap: () {},
                        ),
                        halfCTA(
                            txt: 'نشر الحدث',
                            onTap: () async {
                              if (_eventFormKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = !isLoading;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                    'جاري تحميل الحدث..',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Cairo',
                                    ),
                                  )),
                                );

                                try {
                                  _controllers.forEach((element) {
                                    _controllersText.add(element.text);
                                  });
                                  final targetedAudience =
                                      _targetedAudienceCont.text.split(',');
                                  final event = await eventRef.add({
                                    'image': imagePath,
                                    'title': _eventNameCont.text,
                                    'description': _eventDescriptionCont.text,
                                    'eventType': _eventTypeCont.text,
                                    'starterDate': starterDate,
                                    'endDate': endDate.text,
                                    'starterTime': starterTime.text,
                                    'endTime': endTime.text,
                                    'eventCity': _eventCityCont.text,
                                    'location': _eventLocationCont.text,
                                    'field': _eventFieldCont.text,
                                    'rooms':
                                        FieldValue.arrayUnion(_controllersText),
                                    'acceptsParticapants': acceptsParticipants,
                                    'sendNotification': sendNotifications,
                                    'targetedAudiance':
                                        FieldValue.arrayUnion(targetedAudience),
                                    'eventVisibility': true,
                                    'creationDate': Timestamp.now()
                                  });
                                  if (event == null) {
                                    isLoading = false;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                        'حصل خطأ ما, لم يتم نشر حدثك, أعد المحاولة ..',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Cairo',
                                        ),
                                      )),
                                    );
                                  } else {
                                    isLoading = false;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                        'تم تحميل الحدث بنجاح..',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Cairo',
                                        ),
                                      )),
                                    );
                                    Navigator.pushNamed(context, 'OHome');
                                  }
                                } on FirebaseAuthException catch (e) {}
                              }
                            }),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

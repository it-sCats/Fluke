import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flukepro/utils/SigningProvider.dart';
import 'package:flukepro/utils/notificationProvider.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'cons.dart';
import 'package:http/http.dart' as http;

final _firebaseStorage = FirebaseStorage.instance.ref();

final _firestore = FirebaseFirestore.instance;
final List<String> tokenText = [];

class editEvent extends StatefulWidget {
  String? eventId;
  editEvent({this.eventId});

  @override
  State<editEvent> createState() => _editEventState();
}

class _editEventState extends State<editEvent> {
  final eventRef = _firestore.collection('events');
  final _eventEditKey = GlobalKey<FormState>();
  bool isLoading = false;
  var eventTypes = [
    'ورشة عمل',
    'معرض',
    'محاضرة',
    'ملتقى',
    'إجتماع',
  ];
  var fields = [
    'المجال الطبي',
    'برمجة',
    'مالية',
    'قانون',
    'مجال التقنية',
    'أعمال حرة',
    'أخرى',
    'محاسبة',
    'كتابة محتوى',
    'تصميم جرافيكي'
  ];
  var cities = [
    'طرابلس',
    'بنغازي',
    'مصراتة',
    'الخمس',
    'سبها',
  ];
  TextEditingController? _eventNameCont = TextEditingController();
  TextEditingController _eventTypeCont = TextEditingController();
  TextEditingController endDateCont = TextEditingController();
  Timestamp starterDate = Timestamp(1, 0);
  Timestamp endDate = Timestamp(1, 0);
  TextEditingController? starterDateCont = TextEditingController();
  TextEditingController? starterTime = TextEditingController();
  TextEditingController? endTime = TextEditingController();
  TextEditingController? _eventFieldCont = TextEditingController();
  TextEditingController? _eventDescriptionCont = TextEditingController();
  TextEditingController? _eventLocationCont = TextEditingController();
  TextEditingController? _eventCityCont = TextEditingController();
  TextEditingController? _targetedAudienceCont = TextEditingController();
  List<String> rooms = [];

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

  bool? acceptsParticipants;
  bool? sendNotifications;
  File? image;
  String? imagePath;
  String emptyImage = 'images/emptyIamge.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50),
        decoration: BoxDecoration(color: Colors.white60),
        child: SingleChildScrollView(
            child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('events')
              .doc(widget.eventId?.trim())
              .get(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasData && snapshot.data != null) {
                var eventData = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        onPressed: () {
                          showDialog(
                              //save to drafts dialog
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'هل ترغب في حفظ المعلومات التي أدخلتها؟ ',
                                    textAlign: TextAlign.center,
                                    style:
                                        conHeadingsStyle.copyWith(fontSize: 15),
                                  ),
                                  content: Text(
                                    'يمكنك حفظ المعلومات المدخلة والعودة لها في وقت لاحق',
                                    textAlign: TextAlign.center,
                                    style: conHeadingsStyle.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
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
                                          borderRadius:
                                              BorderRadius.circular(10)),
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
                                  actionsAlignment:
                                      MainAxisAlignment.spaceAround,
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
                          child: imagePath != null
                              ? Image.file(image!)
                              : eventData['image'] != null
                                  ? Image.network(eventData['image'])
                                  : Image.asset(emptyImage),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffd9d9d9),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
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
                        key: _eventEditKey,
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
                                    hintText: eventData['title'],
                                    hintStyle: conTxtFeildHint,
                                    filled: true,
                                    fillColor: Color(0xffF1F1F1),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(10))),
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
                                      hintText: eventData['eventType'],
                                      hintStyle: conTxtFeildHint,
                                      filled: true,
                                      fillColor: Color(0xffF1F1F1),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  style:
                                      conTxtFeildHint.copyWith(color: conBlack),
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
                                      validator: (value) {
                                        if (starterDate != null &&
                                            starterDate.compareTo(endDate) >
                                                0) {
                                          return 'تأكد من صحة تاريخ النهاية';
                                        }

                                        return null;
                                      },
                                      controller: endDateCont,
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime
                                                    .fromMicrosecondsSinceEpoch(
                                                        eventData['endDate']
                                                            .microsecondsSinceEpoch),
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
                                            endDate = Timestamp.fromDate(
                                                pickedDate); //set output date to TextField value.
                                            endDateCont.text = formattedDate
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
                                          hintText: DateTime
                                                  .fromMicrosecondsSinceEpoch(
                                                      eventData['endDate']
                                                          .microsecondsSinceEpoch)
                                              .toString(),
                                          hintStyle: conTxtFeildHint,
                                          filled: true,
                                          fillColor: Color(0xffF1F1F1),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10))),
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
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: InkWell(
                                        child: TextFormField(
                                          controller: starterDateCont,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime
                                                        .fromMicrosecondsSinceEpoch(
                                                            eventData[
                                                                    'starterDate']
                                                                .microsecondsSinceEpoch),
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
                                                starterDateCont!.text =
                                                    formattedDate;
                                                starterDate = Timestamp.fromDate(
                                                    pickedDate); //set output date to TextField value.
                                              });
                                            }
                                          },
                                          readOnly: true,
                                          textDirection: TextDirection.rtl,
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                              hintText: DateTime
                                                      .fromMicrosecondsSinceEpoch(
                                                          eventData[
                                                                  'starterDate']
                                                              .microsecondsSinceEpoch)
                                                  .toString(),
                                              hintStyle: conTxtFeildHint,
                                              filled: true,
                                              fillColor: Color(0xffF1F1F1),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
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
                                        TimeOfDay? pickedTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay(
                                              hour: eventData['endTime'],
                                              minute: 0),
                                        );
                                        //formatted date output using intl package =>  2021-03-16
                                        //you can implement different kind of Date Format here according to your requirement

                                        setState(() {
                                          endTime!.text = pickedTime!.hour
                                              .toString(); //set output date to TextField value.
                                        });
                                      },
                                      readOnly: true,
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.right,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                          hintText:
                                              eventData['endTime'].toString(),
                                          hintStyle: conTxtFeildHint,
                                          filled: true,
                                          fillColor: Color(0xffF1F1F1),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10))),
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
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: InkWell(
                                        child: TextFormField(
                                          controller: starterTime,
                                          onTap: () async {
                                            TimeOfDay? pickedTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay(
                                                  hour:
                                                      eventData['starterTime'],
                                                  minute: 0),
                                            );

                                            //formatted date output using intl package =>  2021-03-16
                                            //you can implement different kind of Date Format here according to your requirement

                                            setState(() {
                                              starterTime!.text = pickedTime!
                                                  .hour
                                                  .toString(); //set output date to TextField value.
                                            });
                                          },
                                          readOnly: true,
                                          textDirection: TextDirection.rtl,
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                              hintText: eventData['starterTime']
                                                  .toString(),
                                              hintStyle: conTxtFeildHint,
                                              filled: true,
                                              fillColor: Color(0xffF1F1F1),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
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
                                  validator: (value) {
                                    value == null ? 'يجب تحديد المدينة' : null;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      hintText: eventData['eventCity'],
                                      hintStyle: conTxtFeildHint,
                                      filled: true,
                                      fillColor: Color(0xffF1F1F1),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  style:
                                      conTxtFeildHint.copyWith(color: conBlack),
                                  items: cities.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(
                                          items), //درنا تحويل من ليستا عادية لليستا يقبلها الدروب داون
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    _eventCityCont!.text = value.toString();
                                  },
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                validator: (value) {
                                  if (value != '' &&
                                      !Uri.parse(_eventLocationCont!.text)
                                          .isAbsolute) return 'رابط غير صالح';
                                },
                                controller: _eventLocationCont,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    hintText: eventData['location'],
                                    hintStyle: conTxtFeildHint,
                                    filled: true,
                                    fillColor: Color(0xffF1F1F1),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(10))),
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
                                      hintText: eventData['field'],
                                      hintStyle: conTxtFeildHint,
                                      filled: true,
                                      fillColor: Color(0xffF1F1F1),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  style:
                                      conTxtFeildHint.copyWith(color: conBlack),
                                  items: fields.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(
                                          items), //درنا تحويل من ليستا عادية لليستا يقبلها الدروب داون
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    _eventFieldCont!.text = value.toString();
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
                                    hintText: eventData['description'],
                                    hintStyle: conTxtFeildHint,
                                    filled: true,
                                    fillColor: Color(0xffF1F1F1),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(10))),
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
                                    style:
                                        conHeadingsStyle.copyWith(fontSize: 20),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  Text(
                                    'حدد  القاعات أو المساحات او المباني التي ستقام \nفيها الجلسات في حال وجود عدة أماكن.',
                                    textAlign: TextAlign.right,
                                    style: conHeadingsStyle.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal),
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
                                          value:
                                              eventData['acceptsParticapants'],
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
                                      style: conHeadingsStyle.copyWith(
                                          fontSize: 20),
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
                                          value: eventData['sendNotification'],
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
                                      style: conHeadingsStyle.copyWith(
                                          fontSize: 20),
                                      textDirection: TextDirection.rtl,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                isLoading
                                    ? CircularProgressIndicator()
                                    : InkWell(
                                        child: Text(
                                          'حفظ كمسودة',
                                          style: conTxtFeildHint.copyWith(
                                              color: Colors.blueGrey,
                                              fontSize: 18),
                                        ),
                                        onTap: () async {
                                          if (_eventEditKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              isLoading = !isLoading;
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                'جاري تعديل بيانات الحدث..',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Cairo',
                                                ),
                                              )),
                                            );

                                            try {
                                              _controllers.forEach((element) {
                                                rooms.add(element.text);
                                              });
                                              var snapshot;
                                              if (imagePath != null) {
                                                snapshot =
                                                    await _firebaseStorage
                                                        .child(imagePath != null
                                                            ? imagePath!
                                                            : emptyImage!)
                                                        .putFile(image!);
                                              }
                                              await eventRef
                                                  .doc(widget.eventId!.trim())
                                                  .update({
                                                'image': imagePath == null
                                                    ? eventData['image']
                                                    : await snapshot!.ref
                                                        .getDownloadURL(),
                                                'title':
                                                    _eventNameCont?.text == ''
                                                        ? eventData['title']
                                                        : _eventNameCont?.text,
                                                'description':
                                                    _eventDescriptionCont
                                                                ?.text ==
                                                            ''
                                                        ? eventData[
                                                            'description']
                                                        : _eventDescriptionCont!
                                                            .text,
                                                'eventType':
                                                    _eventTypeCont.text == ''
                                                        ? eventData['eventType']
                                                        : _eventTypeCont.text,
                                                'starterDate': starterDateCont
                                                            ?.text ==
                                                        ''
                                                    ? eventData['starterDate']
                                                    : starterDate,
                                                'endDate':
                                                    endDateCont.text == ''
                                                        ? eventData['endDate']
                                                        : endDate,
                                                'starterTime': starterTime
                                                            ?.text ==
                                                        ''
                                                    ? eventData['starterTime']
                                                    : int.parse(
                                                        starterTime!.text),
                                                'endTime': endTime?.text == ''
                                                    ? eventData['endTime']
                                                    : int.parse(endTime!.text),
                                                'eventCity':
                                                    _eventCityCont!.text,
                                                'location': _eventLocationCont!
                                                            .text ==
                                                        ''
                                                    ? eventData['location']
                                                    : _eventLocationCont!.text,
                                                'field':
                                                    _eventFieldCont!.text == ''
                                                        ? eventData['field']
                                                        : _eventFieldCont!.text,
                                                'rooms': rooms.isEmpty
                                                    ? eventData['rooms']
                                                    : rooms,
                                                'acceptsParticapants':
                                                    acceptsParticipants == null
                                                        ? eventData[
                                                            'acceptsParticapants']
                                                        : acceptsParticipants,
                                                'sendNotification':
                                                    sendNotifications == null
                                                        ? eventData[
                                                            'sendNotification']
                                                        : sendNotifications,
                                                'eventVisibility': false,
                                              }).then((value) async {
                                                isLoading = false;

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                    'تم تعديل بيانات الحدث بنجاح..',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Cairo',
                                                    ),
                                                  )),
                                                );
                                                Navigator.pushNamed(context,
                                                    'OHome'); //todo give the starter and the final date in value
                                              }).onError((error, stackTrace) {
                                                print(error!.toString());
                                                isLoading = false;
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                    'حصل خطأ ما, لم يتم التعديل, أعد المحاولة ..',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Cairo',
                                                    ),
                                                  )),
                                                );
                                              });
                                              isLoading = false;

                                              // if (sendNotifications) {
                                              //   final users = await FirebaseFirestore
                                              //       .instance
                                              //       .collection('users')
                                              //       .where('userType', isEqualTo: 0)
                                              //       .get();
                                              //   final usersDoc = users.docs;
                                              //
                                              //   final snaplistOfTokens =
                                              //       await FirebaseFirestore
                                              //           .instance
                                              //           .collection('userToken')
                                              //           .where(FieldPath.documentId,
                                              //               arrayContains: usersDoc)
                                              //           .get();
                                              //   final TokensDoc = snaplistOfTokens.docs;
                                              //   TokensDoc.forEach((element) {
                                              //     tokenText.add(element['token']);
                                              //   });
                                              //   sendPushNotification(tokenText, "send from creating event", "I work");
                                              // }

                                            } on FirebaseAuthException catch (e) {}
                                          }
                                        },
                                      ),
                                halfCTA(
                                    txt: 'نشر التغييرات',
                                    onTap: () async {
                                      if (_eventEditKey.currentState!
                                          .validate()) {
                                        setState(() {
                                          isLoading = !isLoading;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
                                            rooms.add(element.text);
                                          });
                                          final targetedAudience =
                                              _targetedAudienceCont!.text
                                                  .split(',');
                                          var snapshot;
                                          if (imagePath != null) {
                                            snapshot = await _firebaseStorage
                                                .child(imagePath!)
                                                .putFile(image!);
                                          }
                                          await eventRef
                                              .doc(widget.eventId!.trim())
                                              .update({
                                            'image': imagePath == null
                                                ? eventData['image']
                                                : await snapshot!.ref
                                                    .getDownloadURL(),
                                            'title': _eventNameCont?.text == ''
                                                ? eventData['title']
                                                : _eventNameCont?.text,
                                            'description': _eventDescriptionCont
                                                        ?.text ==
                                                    ''
                                                ? eventData['description']
                                                : _eventDescriptionCont!.text,
                                            'eventType':
                                                _eventTypeCont.text == ''
                                                    ? eventData['eventType']
                                                    : _eventTypeCont.text,
                                            'starterDate':
                                                starterDateCont?.text == ''
                                                    ? eventData['starterDate']
                                                    : starterDate,
                                            'endDate': endDateCont.text == ''
                                                ? eventData['endDate']
                                                : endDate,
                                            'starterTime': starterTime?.text ==
                                                    ''
                                                ? eventData['starterTime']
                                                : int.parse(starterTime!.text),
                                            'endTime': endTime?.text == ''
                                                ? eventData['endTime']
                                                : int.parse(endTime!.text),
                                            'eventCity': _eventCityCont!.text,
                                            'location':
                                                _eventLocationCont!.text == ''
                                                    ? eventData['location']
                                                    : _eventLocationCont!.text,
                                            'field': _eventFieldCont!.text == ''
                                                ? eventData['field']
                                                : _eventFieldCont!.text,
                                            'rooms': rooms.isEmpty
                                                ? eventData['rooms']
                                                : rooms,
                                            'acceptsParticapants':
                                                acceptsParticipants == null
                                                    ? eventData[
                                                        'acceptsParticapants']
                                                    : acceptsParticipants,
                                            'sendNotification':
                                                sendNotifications == null
                                                    ? eventData[
                                                        'sendNotification']
                                                    : sendNotifications,
                                            'targetedAudiance':
                                                targetedAudience == null
                                                    ? eventData[
                                                        'targetedAudiance']
                                                    : FieldValue.arrayUnion(
                                                        targetedAudience),
                                            'eventVisibility': true,
                                            'creatorID': Provider.of<siggning>(
                                                    context,
                                                    listen: false)
                                                .loggedUser!
                                                .uid,
                                          }).then((value) async {
                                            Navigator.pushReplacementNamed(
                                                context, 'OHome');
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                'تم تحميل الحدث بنجاح..',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Cairo',
                                                ),
                                              )),
                                            ); //todo give the starter and the final date in value
                                          }).onError((error, stackTrace) {
                                            print(error!.toString());
                                            isLoading = false;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                'حصل خطأ ما, لم يتم نشر حدثك, أعد المحاولة ..',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Cairo',
                                                ),
                                              )),
                                            );
                                          });

                                          // if (sendNotifications) {
                                          //   final users = await FirebaseFirestore
                                          //       .instance
                                          //       .collection('users')
                                          //       .where('userType', isEqualTo: 0)
                                          //       .get();
                                          //   final usersDoc = users.docs;
                                          //
                                          //   final snaplistOfTokens =
                                          //       await FirebaseFirestore
                                          //           .instance
                                          //           .collection('userToken')
                                          //           .where(FieldPath.documentId,
                                          //               arrayContains: usersDoc)
                                          //           .get();
                                          //   final TokensDoc = snaplistOfTokens.docs;
                                          //   TokensDoc.forEach((element) {
                                          //     tokenText.add(element['token']);
                                          //   });
                                          //   sendPushNotification(tokenText, "send from creating event", "I work");
                                          // }

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
                );
              } else {
                return Center(
                  child: Image.asset('images/Hands Folder Error.png'),
                );
              }
            }
          },
        )),
      ),
    );
  }
}

sendPushNotification(
    String body, String title, field, eventId, createrId) async {
  try {
    await http
        .post(
            Uri.parse(
                'https://fcm.googleapis.com/v1/projects/fluke-db/messages:send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'Bearer ya29.a0AX9GBdW9Fn_gpAbQCK6awse93FwGrfWsxMnOs4O6B-PlcbIN3b9rzLAT0JV0LMQqePVmw8_lwTr0FY8msBZyl6u6S-ElnaHKQ8O-P5l4_1v-PEUCfvF6XX75317fr8IeLkTuFXCiaxt1q0TATxWoExn3o0xdaCgYKARMSARESFQHUCsbCt4HshZIfek_yhQsExsqfqg0163'
            },
            body: jsonEncode(<String, dynamic>{
              "message": {
                "topic": field,
                "notification": {"title": title, "body": body},
                "data": {
                  "click_action": "FLUTTER_NOTIFICATION_CLICK",
                  "creatorID": createrId,
                  "eventId": eventId
                }
              }
            }))
        .whenComplete(() => debugPrint('done Should send'));
  } catch (e) {
    print('erorr in pushing notifi:$e');
  }
}

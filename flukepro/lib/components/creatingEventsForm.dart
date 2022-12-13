import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'RoomsCreatingView.dart';
import 'cons.dart';

class creatingEvent extends StatefulWidget {
  @override
  State<creatingEvent> createState() => _creatingEventState();
}

class _creatingEventState extends State<creatingEvent> {
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
  TextEditingController endDate = TextEditingController();
  TextEditingController starterDate = TextEditingController();
  TextEditingController starterTime = TextEditingController();
  TextEditingController endTime = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50),
      decoration: BoxDecoration(color: Colors.white60),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 400,
                  child: Image.asset(
                    'images/teemu-paananen-bzdhc5b3Bxs-unsplash.jpg',
                    fit: BoxFit.fill,
                  ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
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
                          onChanged: (value) {},
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
                                  controller: starterDate,
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
                                        starterDate.text = formattedDate
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
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
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
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
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
                    RoomsView(),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flutter/material.dart';

class interestsSelection extends StatefulWidget {
  interestsSelection({this.userType});
  int? userType;
  static const routeName = '/interests';
  @override
  State<interestsSelection> createState() => _interestsSelectionState();
}

class _interestsSelectionState extends State<interestsSelection> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool isErrored = false;
  List<String> interesets = [
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

  List<String> selectedinterestes = [];
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Set;
    final userId = _auth.currentUser!.uid;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 10,
            ),
            child: Align(
                alignment: Alignment.center,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'شاركنا بمجالك أو المجال \nالذي يهمك',
                        textAlign: TextAlign.center,
                        style: conHeadingsStyle,
                      ),
                      Text(
                        'لنوفر لك تجربة استخدام افضل',
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: conOnboardingText.copyWith(color: conBlack),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: multiSelectChip(
                          interesets,
                          onSelectionChanged: (selectedList) {
                            setState(() {
                              selectedinterestes = selectedList;
                            });
                          },
                        ),
                      ),
                      Center(
                        child: Visibility(
                          visible: isErrored,
                          child: Text(
                            'يجب أن تختار إهتمامتك قبل الانتقال للصفحة التانية',
                            style: conErorTxtStyle,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 5,
                      ),
                      CTA(
                          txt: 'حفظ',
                          isFullwidth: true,
                          onTap: () {
                            if (selectedinterestes.isEmpty) {
                              setState(() {
                                isErrored = true;
                              });
                            } else {
                              _firestore
                                  .collection('users')
                                  .doc(userId)
                                  .update({'interests': selectedinterestes});
                              selectedinterestes.forEach((element) {
                                FirebaseMessaging.instance
                                    .subscribeToTopic(element);
                              });
                              Navigator.pushNamed(context, '/redirect');
                            }
                            // Navigator.pushNamed(context, '/home');
                          })
                    ])),
          ),
        ),
      ),
    );
  }
}

class multiSelectChip extends StatefulWidget {
  final List<String> interestsList;
  final Function(List<String>) onSelectionChanged;
  multiSelectChip(this.interestsList, {required this.onSelectionChanged});

  @override
  State<multiSelectChip> createState() => _multiSelectChipState();
}

class _multiSelectChipState extends State<multiSelectChip> {
  @override
  List<String> selectedChoices = []; //list of selected items
  _buildChoiceList() {
    List<Widget> choices = [];

    widget.interestsList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(3.0),
        child: ChoiceChip(
          label: Text(item, style: conlabelsTxt),
          selectedColor: Color(0xff0165FC).withOpacity(.5),
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          selectedShadowColor: Colors.white,
          side: BorderSide(color: conBlack, width: 1),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              //to make it multi selection if selected item is the item that is already selcted it will be removed else will be add to list of selections
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged?.call(selectedChoices);
            });
          },
        ),
      ));
    });
    return choices;
  }

  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

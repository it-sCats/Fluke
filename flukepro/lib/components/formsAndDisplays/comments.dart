import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flukepro/components/cons.dart';
import 'package:flukepro/screens/OrganizersScreens/OHome.dart';
import 'package:flukepro/utils/SigningProvider.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../utils/fireStoreQueries.dart';

TextEditingController con = TextEditingController();
var rating = 0.0;

class commentSection extends StatefulWidget {
  String commenterID;
  String creatorID;
  String eventID;

  commentSection(
      {required this.eventID,
      required this.creatorID,
      required this.commenterID});

  @override
  State<commentSection> createState() => _commentSectionState();
}

class _commentSectionState extends State<commentSection> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<siggning>(context, listen: false)
        .getUserInfoDoc(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: StreamBuilder<QuerySnapshot>(
              stream: getPostComments(widget.eventID),
              builder: (context, snapshot) {
                List<Widget> commentsWidget = [];

                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/Hands Phone.png',
                          width: 250,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'لا توجد أي تعليقات بعد',
                          style: conHeadingsStyle.copyWith(
                              fontSize: 14, color: conBlack.withOpacity(.7)),
                        )
                      ],
                    ), //في حال لايوجد ديكومنتس يتم عرض هذه الصورة
                  );
                  //في حال إحتوت السنابشوت على بيانات سيتم بناءها بإستخدام ليست فيو
                } else {
                  final comments = snapshot.data!.docs;

                  for (var comment in comments) {
                    commentsWidget.add(commenta(
                      commentID: comment.id,
                      creatorID: widget.creatorID,
                      eventID: widget.eventID,
                      userPic: comment['userPic'],
                      rate: comment['rate'],
                      commentBody: comment['body'],
                      commenterID: comment['commenterID'],
                      commenterName: comment['commenterName'],
                      creationDate: comment['creationDate'],
                    ));
                  }
                  return ListView(
                    physics: BouncingScrollPhysics(),
                    reverse: false,
                    children: commentsWidget.isEmpty
                        ? [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 60,
                                ),
                                Center(
                                  child: Image.asset(
                                    'images/Hands Phone.png',
                                    width: 250,
                                  ), //في حال لايوجد ديكومنتس يتم عرض هذه الصورة
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'لايوجد أي تعليقات بعد',
                                  textAlign: TextAlign.center,
                                  style: conLittelTxt12.copyWith(fontSize: 14),
                                )
                              ],
                            )
                          ]
                        : commentsWidget,
                  );
                }
              }),
        ),
        FirebaseAuth.instance.currentUser!.uid != widget.creatorID
            ? Directionality(
                textDirection: TextDirection.ltr,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RatingBar(
                                initialRating: 1,
                                ratingWidget: RatingWidget(
                                  full: Icon(
                                    Icons.star,
                                    color: Color(0xffFFC93C),
                                  ),
                                  half: Icon(
                                    Icons.star_half,
                                    color: Color(0xffFFC93C),
                                  ),
                                  empty: Icon(
                                    Icons.star_border,
                                    color: Color(0xffFFC93C),
                                  ),
                                ),
                                onRatingUpdate: (rate) {
                                  rating = rate;
                                  print(rate);
                                }),
                            Padding(
                              padding: EdgeInsets.only(right: 70.0),
                              child: Text(
                                'تقييم الحدث',
                                style: conlabelsTxt.copyWith(
                                    color: conBlack.withOpacity(.8)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      tileColor: Colors.grey.shade200,
                      title: Column(
                        children: [
                          Divider(),
                          TextFormField(
                            textDirection: TextDirection.rtl,
                            controller: con,
                            decoration: InputDecoration(
                              hintText: 'أكتب تعليقك ....',
                              hintTextDirection: TextDirection.rtl,
                              hintStyle: conlabelsTxt,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        padding: EdgeInsets.only(bottom: 2),
                        icon: Icon(
                          Icons.send,
                          color: conBlue,
                          size: 40,
                        ),
                        onPressed: () async {
                          if (con.text.isNotEmpty) {
                            var previousReview = await FirebaseFirestore
                                .instance
                                .collection('comments')
                                .doc(widget.eventID.toString().trim())
                                .collection('comment')
                                .where('commenterID',
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser!.uid)
                                .get();

                            if (previousReview.docs.isEmpty) {
                              FirebaseFirestore.instance
                                  .collection('comments')
                                  .doc(widget.eventID.toString().trim())
                                  .collection('comment')
                                  .add({
                                'userPic': Provider.of<siggning>(context,
                                        listen: false)
                                    .userInfoDocument!['profilePic'],
                                'body': con.text,
                                'commenterID':
                                    FirebaseAuth.instance.currentUser!.uid,
                                'commenterName': Provider.of<siggning>(context,
                                        listen: false)
                                    .userInfoDocument!['name'],
                                'creationDate': Timestamp.now(),
                                'rate': rating
                              }).whenComplete(() async {
                                QuerySnapshot<Map<String, dynamic>> comments =
                                    await FirebaseFirestore.instance
                                        .collection('comments')
                                        .doc(widget.eventID.trim())
                                        .collection('comment')
                                        .get();
                                var avgRate;
                                var sumOfRates = 0.0;
                                comments.docs.forEach((element) {
                                  sumOfRates =
                                      sumOfRates + element['rate'] as double;
                                });
                                avgRate = sumOfRates / comments.docs.length;
                                print(avgRate);
                                FirebaseFirestore.instance
                                    .collection('events')
                                    .doc(widget.eventID.trim())
                                    .update({'rate': avgRate});
                              });
                              con.clear();
                            } else {
                              showDialog(
                                  //save to drafts dialog
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        'لقد أرسلت تقييم مسبقاً!',
                                        textAlign: TextAlign.center,
                                        style: conHeadingsStyle.copyWith(
                                            fontSize: 15),
                                      ),
                                      content: Text(
                                        'شكرا على المساهمة',
                                        textAlign: TextAlign.center,
                                        style: conHeadingsStyle.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      actions: [
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
                                                con.clear();
                                              },
                                              child: Text(
                                                'حسناً',
                                                textAlign: TextAlign.center,
                                                style:
                                                    conHeadingsStyle.copyWith(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Container()
      ],
    );
  }
}

class commenta extends StatelessWidget {
  String creatorID;
  Timestamp creationDate;
  String commenterID;
  String commentID;
  String eventID;
  String commenterName;
  var rate;
  String userPic;
  String commentBody;

  commenta(
      {required this.creatorID,
      required this.commenterID,
      required this.eventID,
      required this.commenterName,
      required this.userPic,
      required this.commentID,
      required this.rate,
      required this.commentBody,
      required this.creationDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.symmetric(vertical: BorderSide())),
      child: GestureDetector(
        onLongPress: () {
          commenterID == FirebaseAuth.instance.currentUser!.uid
              ? showDialog(
                  //save to drafts dialog
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      icon: Icon(
                        Icons.warning,
                        color: conRed,
                        size: 50,
                      ),
                      title: Text(
                        'سيتم حذف تعليقك ',
                        textAlign: TextAlign.center,
                        style: conHeadingsStyle.copyWith(fontSize: 15),
                      ),
                      actions: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              ' إالغاء الحذف',
                              textAlign: TextAlign.center,
                              style: conHeadingsStyle.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.normal),
                            )),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: conRed,
                              borderRadius: BorderRadius.circular(10)),
                          child: InkWell(
                              onTap: () async {
                                //todo test the delete function
                                await FirebaseFirestore.instance
                                    .collection('comments')
                                    .doc(eventID.toString().trim())
                                    .collection('comment')
                                    .doc(commentID.toString().trim())
                                    .delete()
                                    .then((snapshot) async {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                      'تم حذف الجلسات بنجاح',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Cairo',
                                      ),
                                    )),
                                  );
                                });
                                Navigator.pop(context);
                              },
                              child: Text(
                                'حدف',
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 100),
                    );
                  })
              : {};
        },
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: CircleAvatar(
                    //Avatar
                    backgroundColor: conORange.withOpacity(0),
                    radius: 35,
                    backgroundImage: NetworkImage(userPic),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          commenterName,
                          style: conHeadingsStyle.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: conBlack),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        creatorID == commenterID
                            ? Icon(
                                Icons.stars,
                                color: conORange,
                              )
                            : Container(),
                      ],
                    ),
                    RatingBar(
                        ignoreGestures: true,
                        initialRating: rate,
                        itemSize: 20,
                        ratingWidget: RatingWidget(
                          full: Icon(
                            Icons.star,
                            color: Color(0xffFFC93C),
                          ),
                          half: Icon(
                            Icons.star_half,
                            color: Color(0xffFFC93C),
                          ),
                          empty: Icon(
                            Icons.star_border,
                            color: Color(0xffFFC93C),
                          ),
                        ),
                        onRatingUpdate: (r) {}),
                    Text(
                      commentBody,
                      textAlign: TextAlign.right,
                      style: conHeadingsStyle.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: conBlack),
                    ),
                    Text(
                      timeago.format(DateTime.fromMicrosecondsSinceEpoch(
                          creationDate.microsecondsSinceEpoch)),
                      style: conHeadingsStyle.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: conBlack),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//------------------------------------------------
class TestMe extends StatefulWidget {
  @override
  _TestMeState createState() => _TestMeState();
}

class _TestMeState extends State<TestMe> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List filedata = [
    {
      'name': 'عائشة ',
      'pic': 'https://picsum.photos/300/30',
      'message': 'الحدث رائع',
      'date': '2021-01-01 12:00:00'
    },
    {
      'name': 'وئام 123',
      'pic': 'https://www.adeleyeayodeji.com/img/IMG_20200522_121756_834_2.jpg',
      'message': 'Very cool',
      'date': '2021-01-01 12:00:00'
    },
    {
      'name': 'رهف عكعك',
      'pic': 'assets/img/userpic.jpg',
      'message': 'وين مكانه بالضبط ',
      'date': '2021-01-01 12:00:00'
    },
    {
      'name': 'محمد مازن',
      'pic': 'https://picsum.photos/300/30',
      'message': 'من أفضل الأحداث ',
      'date': '2021-01-01 12:00:00'
    },
  ];

  Widget commentChild(data) {
    return ListView(
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () async {
                  // Display the image in large form.
                  print("Comment Clicked");
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: CommentBox.commentImageParser(
                          imageURLorPath: data[i]['pic'])),
                ),
              ),
              title: Text(
                data[i]['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(data[i]['message']),
              trailing: Text(data[i]['date'], style: TextStyle(fontSize: 10)),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "التعليقات",
          style: conHeadingsStyle,
        ),
        backgroundColor: conBlue,
      ),
      body: Container(
        child: CommentBox(
          userImage: CommentBox.commentImageParser(
              imageURLorPath: "assets/img/userpic.jpg"),
          child: commentChild(filedata),
          labelText: 'أكتب تعليق',
          errorText: 'لا يجب أن يكون التعليق فارغا',
          withBorder: false,
          sendButtonMethod: () {
            if (formKey.currentState!.validate()) {
              print(commentController.text);
              setState(() {
                var value = {
                  'name': 'New User',
                  'pic':
                      'https://lh3.googleusercontent.com/a-/AOh14GjRHcaendrf6gU5fPIVd8GIl1OgblrMMvGUoCBj4g=s400',
                  'message': commentController.text,
                  'date': '2021-01-01 12:00:00'
                };
                filedata.insert(0, value);
              });
              commentController.clear();
              FocusScope.of(context).unfocus();
            } else {
              print("Not validated");
            }
          },
          formKey: formKey,
          commentController: commentController,
          backgroundColor: conBlue,
          textColor: Colors.white,
          sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
        ),
      ),
    );
  }
}

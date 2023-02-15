import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flukepro/components/eventDisplay.dart';
import 'package:flukepro/utils/SigningProvider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../components/cons.dart';
import '../../components/events.dart';
import '../../components/visitorEventprev.dart';
import '../../utils/fireStoreQueries.dart';

String userIn = '';
var userInfo;
File? image;
String? imagePath;

class Oprofile extends StatefulWidget {
  String? OrganizerToDisplayID;
  Oprofile({this.OrganizerToDisplayID});
  @override
  State<Oprofile> createState() => _OprofileState();
}

getORganizerInfo(id) async {
  DocumentSnapshot<Map<String, dynamic>> creator =
      await FirebaseFirestore.instance.collection('users').doc(id.trim()).get();
  userInfo = creator.data();
  return creator.data();
}

class _OprofileState extends State<Oprofile> with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userInfo = widget.OrganizerToDisplayID == null
        ? Provider.of<siggning>(context, listen: false).getUserInfoDoc(
            Provider.of<siggning>(context, listen: false).loggedUser!.uid)
        : getORganizerInfo(widget.OrganizerToDisplayID);
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    // userInfo = Provider.of<siggning>(context, listen: false).getUserInfoDoc(
    //     widget.OrganizerToDisplayID == null
    //         ? Provider.of<siggning>(context, listen: false).loggedUser!.uid
    //         : widget.OrganizerToDisplayID);
    Provider.of<siggning>(context, listen: false)
        .getUserInfoDoc(FirebaseAuth.instance.currentUser!.uid);

    TabController _tabCont = TabController(length: 2, vsync: this);
    return widget.OrganizerToDisplayID == null
        ? //if from outside
        SafeArea(
            child: DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder: (context, bool) {
                return [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    var snapshot;
                                    final ImagePicker _picker = ImagePicker();
                                    // Pick an image
                                    final imageFile = await _picker.pickImage(
                                        source: ImageSource.gallery);
                                    imageFile != null
                                        ? {
                                            setState(() {
                                              imagePath = imageFile!.path;
                                              image = File(imageFile!.path);
                                            }),
                                            snapshot = await FirebaseStorage
                                                .instance
                                                .ref()
                                                .child(imagePath != null
                                                    ? imagePath!
                                                    : 'https://p.kindpng.com/picc/s/272-2720630_grey-user-hd-png-download.png'!)
                                                .putFile(image!),
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .update({
                                              'profilePic': await snapshot!.ref
                                                  .getDownloadURL()
                                            })
                                          }
                                        : null;

                                    // Capture a photo
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'تغيير الصورة',
                                        style: conTxtLink,
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.edit)),
                                    ],
                                  ),
                                ),
                                CircleAvatar(
                                    //Avatar
                                    backgroundColor:
                                        Color(0xff).withOpacity(0.5),
                                    radius: 50,
                                    backgroundImage: image == null
                                        ? NetworkImage(Provider.of<siggning>(
                                                            context,
                                                            listen: false)
                                                        .userInfoDocument![
                                                    'profilePic'] ==
                                                null
                                            ? 'https://i.guim.co.uk/img/media/26392d05302e02f7bf4eb143bb84c8097d09144b/446_167_3683_2210/master/3683.jpg?width=620&quality=45&dpr=2&s=none'
                                            : Provider.of<siggning>(context,
                                                        listen: false)
                                                    .userInfoDocument![
                                                'profilePic'])
                                        : FileImage(image!) as ImageProvider),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 60.0, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  Provider.of<siggning>(context, listen: false)
                                      .userInfoDocument!['name'],
                                  style: conHeadingsStyle.copyWith(
                                      color: conBlack.withOpacity(.8),
                                      fontSize: 15),
                                ),
                                Text(
                                  "منظم",
                                  style: conHeadingsStyle.copyWith(
                                      color: conBlack
                                          .withOpacity(.6)
                                          .withOpacity(0.50),
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 25,
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ]),
                  ),
                ];
              },
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                //الأساسي

                children: [
                  TabBar(
                    unselectedLabelStyle: conLittelTxt12.copyWith(fontSize: 15),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    labelStyle: conLittelTxt12,
                    indicator: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 3, color: conBlue))),
                    controller: _tabCont,
                    tabs: [
                      Tab(
                        child: Text(
                          'أحداث',
                          style: conLittelTxt12.copyWith(fontSize: 15),
                        ),
                      ),
                      Tab(
                        child: Text(
                          widget.OrganizerToDisplayID == null
                              ? 'مسودة الاحداث'
                              : 'معلومات المنظم',
                          style: conLittelTxt12.copyWith(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    // color: Color.fromARGB(255, 255, 255, 255),

                    child: TabBarView(
                      controller: _tabCont,
                      children: [
                        FutureBuilder(
                            //todo change this to streambuilder
                            //الايفينتس متاع المنظم

                            //باش نبنو الداتا الي بنجيبوها من قاعدة البيانات نحتاجو نحطوها في الفيوتشر بيلدر
                            future: getOrganizersEvent(
                                context,
                                Provider.of<siggning>(context, listen: false)
                                    .loggedUser!
                                    .uid),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                //في حال لم يتم الاتصال يتم إظهار علامة تحميل
                                return CircularProgressIndicator();
                              } else {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: Image.asset(
                                        'images/Hands Phone.png'), //في حال لايوجد ديكومنتس يتم عرض هذه الصورة
                                  );
                                  //في حال إحتوت السنابشوت على بيانات سيتم بناءها بإستخدام ليست فيو
                                } else {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 100.0),
                                    child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 300,
                                              childAspectRatio: 4 / 5,
                                              crossAxisSpacing: 0,
                                              mainAxisSpacing: 5),
                                      itemBuilder: (context, index) {
                                        var eventData = snapshot.data![index];
                                        Map likes = eventData['likes'];
                                        int likesCount = likes.length;

                                        return GestureDetector(
                                          child: OrganizerEventPreview(
                                              //ويدجيت خاصة بالكارت الخاص بالحدث يتم تمرير البيانت التي تم إحضارها من قاعدة البيانات إليها
                                              title: eventData['title'],
                                              image: eventData['image'],
                                              description:
                                                  eventData['description'],
                                              field: eventData['field'],
                                              location: eventData['location'],
                                              city: eventData['eventCity'],
                                              starterDate:
                                                  eventData['starterDate'],
                                              endDate: eventData['endDate'],
                                              starterTime:
                                                  eventData['starterTime'],
                                              endTime: eventData['endTime'],
                                              eventType: eventData['eventType'],
                                              creationDate:
                                                  eventData['creationDate'],
                                              acceptsParticapants: eventData[
                                                  'acceptsParticapants'],
                                              eventVisibilty:
                                                  eventData['eventVisibility']),
                                          onTap: () {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                elevation: 100,
                                                context: context,
                                                builder: (context) =>
                                                    eventDisplay(
                                                      wholePage: true,
                                                      justDisplay: true,
                                                      id: eventData['id'],
                                                      title: eventData['title'],
                                                      description: eventData[
                                                          'description'],
                                                      starterDate: eventData[
                                                          'starterDate'],
                                                      location:
                                                          eventData['location'],
                                                      image: eventData['image'],
                                                      endDate:
                                                          eventData['endDate'],
                                                      starterTime: eventData[
                                                          'starterTime'],
                                                      endTime:
                                                          eventData['endTime'],
                                                      creationDate: eventData[
                                                          'creationDate'],
                                                      city: eventData[
                                                          'eventCity'],
                                                      acceptsParticapants:
                                                          eventData[
                                                              'acceptsParticapants'],
                                                      eventVisibilty: eventData[
                                                          'eventVisibility'],
                                                      visitorsNum: visitorsNum,
                                                      likes: likesCount,
                                                      rate: eventData['rate'],
                                                      creatorID: eventData[
                                                          'creatorID'],
                                                      creatorName: eventData[
                                                          'creatorName'],
                                                    ));
                                          },
                                        );
                                      },
                                      itemCount: snapshot.data?.length,
                                    ),
                                  );
                                }
                              }
                            }),
                        widget.OrganizerToDisplayID == null
                            ? eventDrafts()
                            : OrganizersInfo(
                                widget.OrganizerToDisplayID.toString())
                      ],
                    ),
                  )
                ],
              ),
            ),
          ))
        : Scaffold(
            body: SafeArea(
                child: DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder: (context, bool) {
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        FutureBuilder<Map<String, dynamic>?>(
                            future: Provider.of<siggning>(context)
                                .getFastUserInfoDoc(
                                    widget.OrganizerToDisplayID),
                            builder: (context, snapshot) {
                              Map<String, dynamic>? inf = snapshot!.data;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(50),
                                    child: CircleAvatar(
                                        //Avatar
                                        backgroundColor:
                                            conORange.withOpacity(0.5),
                                        radius: 50,
                                        backgroundImage: NetworkImage(inf ==
                                                null
                                            ? 'https://p.kindpng.com/picc/s/272-2720630_grey-user-hd-png-download.png'
                                            : inf!['profilePic'])),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: 60.0, top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        inf == null
                                            ? Divider(
                                                thickness: 10,
                                                indent: 200,
                                                color: conBlack.withOpacity(.2),
                                              )
                                            : Text(
                                                inf!['name'],
                                                style:
                                                    conHeadingsStyle.copyWith(
                                                        color: conBlack
                                                            .withOpacity(.8),
                                                        fontSize: 15),
                                              ),
                                        inf == null
                                            ? Divider(
                                                thickness: 10,
                                                indent: 200,
                                                color: conBlack.withOpacity(.2),
                                              )
                                            : Text(
                                                "منظم",
                                                style:
                                                    conHeadingsStyle.copyWith(
                                                        color: conBlack
                                                            .withOpacity(.6)
                                                            .withOpacity(0.50),
                                                        fontSize: 15),
                                              ),
                                        SizedBox(
                                          height: 25,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            })
                      ]),
                    )
                  ];
                },
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  //الأساسي

                  children: [
                    TabBar(
                      unselectedLabelStyle:
                          conLittelTxt12.copyWith(fontSize: 15),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      labelStyle: conLittelTxt12,
                      indicator: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(width: 3, color: conBlue))),
                      controller: _tabCont,
                      tabs: [
                        Tab(
                          child: Text(
                            'أحداث',
                            style: conLittelTxt12.copyWith(fontSize: 15),
                          ),
                        ),
                        Tab(
                          child: Text(
                            widget.OrganizerToDisplayID == null
                                ? 'مسودة الاحداث'
                                : 'معلومات المنظم',
                            style: conLittelTxt12.copyWith(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      // color: Color.fromARGB(255, 255, 255, 255),

                      child: TabBarView(
                        controller: _tabCont,
                        children: [
                          FutureBuilder(
                              //todo change this to streambuilder
                              //الايفينتس متاع المنظم

                              //باش نبنو الداتا الي بنجيبوها من قاعدة البيانات نحتاجو نحطوها في الفيوتشر بيلدر
                              future: getOrganizersEvent(
                                  context, widget.OrganizerToDisplayID),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  //في حال لم يتم الاتصال يتم إظهار علامة تحميل
                                  return CircularProgressIndicator();
                                } else {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: Image.asset(
                                          'images/Hands Phone.png'), //في حال لايوجد ديكومنتس يتم عرض هذه الصورة
                                    );
                                    //في حال إحتوت السنابشوت على بيانات سيتم بناءها بإستخدام ليست فيو
                                  } else {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 0),
                                      child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 300,
                                                childAspectRatio: 4 / 5,
                                                crossAxisSpacing: 0,
                                                mainAxisSpacing: 5),
                                        itemBuilder: (context, index) {
                                          var eventData = snapshot.data![index];
                                          int likesCount =
                                              eventData['likes'].length;
                                          return GestureDetector(
                                            child: OrganizerEventPreview(
                                                //ويدجيت خاصة بالكارت الخاص بالحدث يتم تمرير البيانت التي تم إحضارها من قاعدة البيانات إليها
                                                title: eventData['title'],
                                                image: eventData['image'],
                                                description:
                                                    eventData['description'],
                                                field: eventData['field'],
                                                location: eventData['location'],
                                                city: eventData['eventCity'],
                                                starterDate:
                                                    eventData['starterDate'],
                                                endDate: eventData['endDate'],
                                                starterTime:
                                                    eventData['starterTime'],
                                                endTime: eventData['endTime'],
                                                eventType:
                                                    eventData['eventType'],
                                                creationDate:
                                                    eventData['creationDate'],
                                                acceptsParticapants: eventData[
                                                    'acceptsParticapants'],
                                                eventVisibilty: eventData[
                                                    'eventVisibility']),
                                            onTap: () {
                                              showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  elevation: 100,
                                                  context: context,
                                                  builder: (context) =>
                                                      eventDisplay(
                                                        wholePage: true,
                                                        justDisplay: true,
                                                        id: eventData['id'],
                                                        title:
                                                            eventData['title'],
                                                        description: eventData[
                                                            'description'],
                                                        starterDate: eventData[
                                                            'starterDate'],
                                                        location: eventData[
                                                            'location'],
                                                        image:
                                                            eventData['image'],
                                                        endDate: eventData[
                                                            'endDate'],
                                                        starterTime: eventData[
                                                            'starterTime'],
                                                        endTime: eventData[
                                                            'endTime'],
                                                        creationDate: eventData[
                                                            'creationDate'],
                                                        city: eventData[
                                                            'eventCity'],
                                                        acceptsParticapants:
                                                            eventData[
                                                                'acceptsParticapants'],
                                                        eventVisibilty: eventData[
                                                            'eventVisibility'],
                                                        likes: likesCount,
                                                        rate: eventData['rate'],
                                                        visitorsNum:
                                                            visitorsNum,
                                                        creatorID: eventData[
                                                            'creatorID'],
                                                        creatorName: eventData[
                                                            'creatorName'],
                                                      ));
                                            },
                                          );
                                        },
                                        itemCount: snapshot.data?.length,
                                      ),
                                    );
                                  }
                                }
                              }),
                          OrganizersInfo(widget.OrganizerToDisplayID.toString())
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
          );
  }
}

class OrganizersInfo extends StatelessWidget {
  String id;
  OrganizersInfo(this.id);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Map<String, dynamic>?>(
        future: Provider.of<siggning>(context).getFastUserInfoDoc(id),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var inf = snapshot.data;

            return Column(
              children: [Text(inf!['name']), Text(inf!['email'])],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class eventDrafts extends StatelessWidget {
  const eventDrafts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(

        //باش نبنو الداتا الي بنجيبوها من قاعدة البيانات نحتاجو نحطوها في الفيوتشر بيلدر
        stream: FirebaseFirestore.instance
            .collection('events')
            .where('creatorID',
                isEqualTo: Provider.of<siggning>(context).loggedUser!.uid)
            .where('eventVisibility', isEqualTo: false)
            .orderBy('creationDate', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            print('${snapshot.data} the data of eventsss');
            return Center(
              child: Image.asset(
                  'images/Hands Phone.png'), //في حال لايوجد ديكومنتس يتم عرض هذه الصورة
            );
            //في حال إحتوت السنابشوت على بيانات سيتم بناءها بإستخدام ليست فيو
          } else {
            print('${snapshot.data!.docs} the data of eventsss');
            final events = snapshot.data!.docs;

            List<Widget> eventWidget = [];
            for (var eventa in events) {
              Timestamp strat = eventa['starterDate'];
              Timestamp end = eventa['endDate'];
              int likesCount = eventa['likes'].length;
              // print(DateTime.fromMicrosecondsSinceEpoch(
              //     strat.microsecondsSinceEpoch));
              // print(DateTime.fromMicrosecondsSinceEpoch(
              //     end.microsecondsSinceEpoch)); //testing
              {
                eventWidget.add(Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: GestureDetector(
                    child: OrganizerEventPreview(
                      //ويدجيت خاصة بالكارت الخاص بالحدث يتم تمرير البيانت التي تم إحضارها من قاعدة البيانات إليها
                      title: eventa['title'],
                      image: eventa['image'],
                      description: eventa['description'],
                      field: eventa['field'],
                      location: eventa['location'],
                      city: eventa['eventCity'],
                      starterDate: eventa['starterDate'],
                      endDate: eventa['endDate'],
                      starterTime: eventa['starterTime'],
                      endTime: eventa['endTime'],
                      eventType: eventa['eventType'],
                      creationDate: eventa['creationDate'],
                      acceptsParticapants: eventa['acceptsParticapants'],
                      eventVisibilty: eventa['eventVisibility'],
                    ),
                    onTap: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          elevation: 100,
                          context: context,
                          builder: (context) => eventDisplay(
                                wholePage: true,
                                justDisplay: false,
                                id: eventa['id'],
                                title: eventa['title'],
                                description: eventa['description'],
                                starterDate: eventa['starterDate'],
                                location: eventa['location'],
                                image: eventa['image'],
                                endDate: eventa['endDate'],
                                starterTime: eventa['starterTime'],
                                eventType: eventa['eventType'],
                                endTime: eventa['endTime'],
                                field: eventa['field'],
                                creationDate: eventa['creationDate'],
                                city: eventa['eventCity'],
                                acceptsParticapants:
                                    eventa['acceptsParticapants'],
                                likes: likesCount,
                                rate: eventa['rate'],
                                eventVisibilty: eventa['eventVisibility'],
                                visitorsNum: visitorsNum,
                                creatorID: eventa['creatorID'],
                                creatorName: eventa['creatorName'],
                              ));
                    },
                  ),
                ));
              }
            }
            return GridView.custom(
              padding: EdgeInsets.symmetric(vertical: 05),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 4 / 5,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 2),
              childrenDelegate: SliverChildListDelegate(eventWidget),
            );
          }
          //في حال لم يتم الاتصال يتم إظهار علامة تحميل
        });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flukepro/components/eventDisplay.dart';
import 'package:flukepro/utils/SigningProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/cons.dart';
import '../../components/events.dart';
import '../../components/visitorEventprev.dart';
import '../../utils/fireStoreQueries.dart';

String userIn = '';

class Oprofile extends StatefulWidget {
  @override
  State<Oprofile> createState() => _OprofileState();
}

class _OprofileState extends State<Oprofile> with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<siggning>(context, listen: false)
        .getUserInfoDoc(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    Provider.of<siggning>(context, listen: false).userInfoDocument == null
        ? userIn = ''
        : userIn = Provider.of<siggning>(context, listen: false)
            .userInfoDocument!['name'];
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<siggning>(context, listen: false)
        .getUserInfoDoc(FirebaseAuth.instance.currentUser!.uid);

    TabController _tabCont = TabController(length: 2, vsync: this);
    return SafeArea(
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
                      child: CircleAvatar(
                        //Avatar
                        backgroundColor: Color(0xff).withOpacity(0),
                        radius: 50,
                        backgroundImage: NetworkImage(
                            'https://i.guim.co.uk/img/media/26392d05302e02f7bf4eb143bb84c8097d09144b/446_167_3683_2210/master/3683.jpg?width=620&quality=45&dpr=2&s=none'),
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
                                color: conBlack.withOpacity(.8), fontSize: 15),
                          ),
                          Text(
                            "منظم",
                            style: conHeadingsStyle.copyWith(
                                color:
                                    conBlack.withOpacity(.6).withOpacity(0.50),
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
                  border: Border(bottom: BorderSide(width: 3, color: conBlue))),
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
                    'مسودة الاحداث',
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
                      future: getOrganizersEvent(context),
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

                                  return GestureDetector(
                                    child: OrganizerEventPreview(
                                        //ويدجيت خاصة بالكارت الخاص بالحدث يتم تمرير البيانت التي تم إحضارها من قاعدة البيانات إليها
                                        title: eventData['title'],
                                        image: eventData['image'],
                                        description: eventData['description'],
                                        field: eventData['field'],
                                        location: eventData['location'],
                                        city: eventData['eventCity'],
                                        starterDate: eventData['starterDate'],
                                        endDate: eventData['endDate'],
                                        starterTime: eventData['starterTime'],
                                        endTime: eventData['endTime'],
                                        eventType: eventData['eventType'],
                                        creationDate: eventData['creationDate'],
                                        acceptsParticapants:
                                            eventData['acceptsParticapants'],
                                        eventVisibilty:
                                            eventData['eventVisibility']),
                                    onTap: () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          elevation: 100,
                                          context: context,
                                          builder: (context) => eventDisplay(
                                                wholePage: false,
                                                justDisplay: true,
                                                id: eventData['id'],
                                                title: eventData['title'],
                                                description:
                                                    eventData['description'],
                                                starterDate:
                                                    eventData['starterDate'],
                                                location: eventData['location'],
                                                image: eventData['image'],
                                                endDate: eventData['endDate'],
                                                starterTime:
                                                    eventData['starterTime'],
                                                endTime: eventData['endTime'],
                                                creationDate:
                                                    eventData['creationDate'],
                                                city: eventData['eventCity'],
                                                acceptsParticapants: eventData[
                                                    'acceptsParticapants'],
                                                eventVisibilty: eventData[
                                                    'eventVisibility'],
                                                visitorsNum: visitorsNum,
                                                creatorID:
                                                    eventData['creatorID'],
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
                  eventDrafts()
                ],
              ),
            )
          ],
        ),
      ),
    ));
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
            .where('eventVisibility', isEqualTo: false)
            .orderBy('creationDate', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
              final events = snapshot.data!.docs;

              List<Widget> eventWidget = [];
              for (var eventa in events) {
                Timestamp strat = eventa['starterDate'];
                Timestamp end = eventa['endDate'];
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
                                wholePage: false,
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
                                eventVisibilty: eventa['eventVisibility'],
                                visitorsNum: visitorsNum,
                                creatorID: eventa['creatorID']));
                      },
                    ),
                  ));
                }
              }
              return GridView.custom(
                padding: EdgeInsets.symmetric(vertical: 10),
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 4 / 5,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 5),
                childrenDelegate: SliverChildListDelegate(eventWidget),
              );
            }
          }
        });
  }
}

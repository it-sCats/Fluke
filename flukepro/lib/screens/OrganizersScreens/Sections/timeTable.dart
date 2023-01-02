import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../components/cons.dart';
import '../../../components/eventDisplay.dart';
import '../../../components/events.dart';
import '../../../utils/fireStoreQueries.dart';
import '../../../utils/helperFunctions.dart';

List<Tab> daysTabs = [];

class timeTable extends StatefulWidget {
  const timeTable({Key? key}) : super(key: key);

  @override
  State<timeTable> createState() => _timeTableState();
}

Future<DocumentSnapshot<Map<String, dynamic>>> getEventInfoForTimetable(
    eventID) async {
  return await FirebaseFirestore.instance
      .collection('events')
      .doc(eventID)
      .get();
}

class _timeTableState extends State<timeTable> with TickerProviderStateMixin {
  @override
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getEventInfoForTimetable(args['enevtId']),
        builder: (context, AsyncSnapshot snapshot) {
          final eventData = snapshot.data();
          print(eventData);
          Timestamp starterDate = eventData['starterDate'];
          Timestamp endDate = eventData['endDate'];

          List days = List.filled(
              DateTime.fromMicrosecondsSinceEpoch(
                      endDate.microsecondsSinceEpoch)
                  .difference(DateTime.fromMicrosecondsSinceEpoch(
                      starterDate.microsecondsSinceEpoch))
                  .inDays,
              null, //the list doesn't work cancle the function and calculalte days here
              growable: true);
          //calculate the different between starter date and end date0
          TabController _tabCont = TabController(length: 2, vsync: this);
          int eventDays = 0;
          days.forEach((element) {
            while (eventDays <
                DateTime.fromMicrosecondsSinceEpoch(
                        endDate.microsecondsSinceEpoch)
                    .difference(DateTime.fromMicrosecondsSinceEpoch(
                        starterDate.microsecondsSinceEpoch))
                    .inDays)
              daysTabs.add(Tab(
                height: 100,
                text: 'اليوم $eventDays',
              ));
            eventDays++;
          });
          // print(days.length);
          // print(daysTabs);

          // print(DateTime.fromMicrosecondsSinceEpoch(
          //         endDate.microsecondsSinceEpoch)
          //     .difference(DateTime.fromMicrosecondsSinceEpoch(
          //         starterDate.microsecondsSinceEpoch))
          //     .inDays);
          // print(DateTime.fromMicrosecondsSinceEpoch(
          //     endDate.microsecondsSinceEpoch));
          // print(DateTime.fromMicrosecondsSinceEpoch(
          //     starterDate.microsecondsSinceEpoch));

          //الايفينتس متاع المنظم

          return DefaultTabController(
            //take the idea of converting
            length: DateTime.fromMicrosecondsSinceEpoch(
                    endDate.microsecondsSinceEpoch)
                .difference(DateTime.fromMicrosecondsSinceEpoch(
                    starterDate.microsecondsSinceEpoch))
                .inDays,
            child:
                //generate tabs based on days of event day 1 day 2
                Column(
              children: [
                TabBar(
                    tabs: daysTabs,
                    labelStyle: conLittelTxt12,
                    labelColor: conBlack),
                Expanded(
                  child: TabBarView(
                    children: [Container(), Container()],
                  ),
                ),
              ],
            )
            // Padding(
            //   padding: EdgeInsets.only(bottom: 100.0),
            //   child: GridView.builder(
            //     gridDelegate:
            //         SliverGridDelegateWithMaxCrossAxisExtent(
            //             maxCrossAxisExtent: 300,
            //             childAspectRatio: 4 / 5,
            //             crossAxisSpacing: 0,
            //             mainAxisSpacing: 5),
            //     itemBuilder: (context, index) {
            //       var eventData = snapshot.data![index];
            //
            //       return GestureDetector(
            //         child: OrganizerEventPreview(
            //             //ويدجيت خاصة بالكارت الخاص بالحدث يتم تمرير البيانت التي تم إحضارها من قاعدة البيانات إليها
            //             title: eventData['title'],
            //             image: eventData['image'],
            //             description: eventData['description'],
            //             field: eventData['field'],
            //             location: eventData['location'],
            //             city: eventData['eventCity'],
            //             starterDate: eventData['starterDate'],
            //             endDate: eventData['endDate'],
            //             starterTime: eventData['starterTime'],
            //             endTime: eventData['endTime'],
            //             eventType: eventData['eventType'],
            //             creationDate: eventData['creationDate'],
            //             acceptsParticapants:
            //                 eventData['acceptsParticapants'],
            //             eventVisibilty:
            //                 eventData['eventVisibility']),
            //         onTap: () {
            //           showModalBottomSheet(
            //               isScrollControlled: true,
            //               elevation: 100,
            //               context: context,
            //               builder: (context) => eventDisplay(
            //                     wholePage: false,
            //                     justDisplay: true,
            //                     id: eventData['id'],
            //                     title: eventData['title'],
            //                     description:
            //                         eventData['description'],
            //                     starterDate:
            //                         eventData['starterDate'],
            //                     location: eventData['location'],
            //                     image: eventData['image'],
            //                     endDate: eventData['endDate'],
            //                     starterTime:
            //                         eventData['starterTime'],
            //                     endTime: eventData['endTime'],
            //                     creationDate:
            //                         eventData['creationDate'],
            //                     city: eventData['eventCity'],
            //                     acceptsParticapants: eventData[
            //                         'acceptsParticapants'],
            //                     eventVisibilty:
            //                         eventData['eventVisibility'],
            //                     creatorID: eventData['creatorID'],
            //                   ));
            //         },
            //       );
            //     },
            //     itemCount: snapshot.data?.length,
            //   ),
            // ),
            ,
          );
        },
      ),
    );
  }
}

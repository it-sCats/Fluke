import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../components/cons.dart';
import '../../components/eventDisplay.dart';

class ExploreScreen extends StatefulWidget {
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  TextEditingController cont = TextEditingController();
  List searchResult = [];

  void searchEvent(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('events')
        .where('eventSearchCases', arrayContains: query)
        .get();
    final field = await FirebaseFirestore.instance
        .collection('events')
        .where('fieldSearchCases', arrayContains: query)
        .get();
    setState(() {
      searchResult = result.docs.map((e) => e.data()).toList();
      List fieldSearch = field.docs.map((e) => e.data()).toList();
      searchResult.addAll(fieldSearch);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextFormField(
                textDirection: TextDirection.rtl,
                controller: cont,
                keyboardType: TextInputType.text,
                onChanged: (String query) {
                  searchEvent(query);
                },
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "...ابحث عن أحداث",
                  hintStyle: conTxtFeildHint,
                  prefixIcon: new Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 155, 5, 33)),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResult.length,
              itemBuilder: (context, index) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          elevation: 100,
                          context: context,
                          builder: (context) => eventDisplay(
                                wholePage: true,
                                justDisplay: false,
                                id: searchResult[index]['id'],
                                title: searchResult[index]['title'],
                                description: searchResult[index]['description'],
                                starterDate: searchResult[index]['starterDate'],
                                location: searchResult[index]['location'],
                                image: searchResult[index]['image'],
                                endDate: searchResult[index]['endDate'],
                                starterTime: searchResult[index]['starterTime'],
                                eventType: searchResult[index]['eventType'],
                                endTime: searchResult[index]['endTime'],
                                field: searchResult[index]['field'],
                                creationDate: searchResult[index]
                                    ['creationDate'],
                                likes: searchResult[index]['likes'].length,
                                rate: searchResult[index]['rate'],
                                city: searchResult[index]['eventCity'],
                                acceptsParticapants: searchResult[index]
                                    ['acceptsParticapants'],
                                eventVisibilty: searchResult[index]
                                    ['eventVisibility'],
                                visitorsNum: 0,
                                creatorID: searchResult[index]['creatorID'],
                                creatorName: searchResult[index]['creatorName'],
                              ));
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 2),
                      decoration: BoxDecoration(
                          border: Border.symmetric(vertical: BorderSide()),
                          color: Colors.white70.withOpacity(1)),
                      child: Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: CircleAvatar(
                                  //Avatar
                                  backgroundColor: conORange.withOpacity(.8),
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                      searchResult[index]['image']),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    searchResult[index]['title'],
                                    textAlign: TextAlign.right,
                                    style: conHeadingsStyle.copyWith(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                        color: conBlack),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: conORange,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            searchResult[index]['eventCity'],
                                            style: conHeadingsStyle.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: conBlack),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month_rounded,
                                            color: conORange.withOpacity(.8),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                    searchResult[index]
                                                            ['starterDate']
                                                        .microsecondsSinceEpoch)
                                                .toString()
                                                .split(' ')
                                                .first,
                                            style: conHeadingsStyle.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: conBlack),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.work,
                                            color: conORange.withOpacity(.8),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            searchResult[index]['field'],
                                            style: conHeadingsStyle.copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: conBlack),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    ));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/fireStoreQueries.dart';
import '../cons.dart';

class displayParticipants extends StatelessWidget {
  String eventID;
  displayParticipants({required this.eventID});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: getParticipantOfEvent(eventID),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty)
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index];
              return Container(
                decoration: BoxDecoration(
                    border: Border.symmetric(vertical: BorderSide())),
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
                            backgroundColor: conORange.withOpacity(0),
                            radius: 30,
                            backgroundImage: NetworkImage(
                                'https://i.guim.co.uk/img/media/26392d05302e02f7bf4eb143bb84c8097d09144b/446_167_3683_2210/master/3683.jpg?width=620&quality=45&dpr=2&s=none'),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['name'],
                              textAlign: TextAlign.right,
                              style: conHeadingsStyle.copyWith(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: conBlack),
                            ),
                            Text(
                              data['participationType'],
                              style: conHeadingsStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: conBlack),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        else {
          return Center(
            child: Text(' '),
          );
        }
      },
    );
  }
}

import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';

class event extends StatelessWidget {
  String title;
  String? image;
  String? eventType;
  DateTime starterDate;
  DateTime endDate;
  DateTime starterTime;
  DateTime endTime;
  var field;
  String description;
  DateTime creationDate;
  List<String>? room;
  String? location;
  bool acceptsParticapants;
  List<String>? targetedAudiance;
  bool eventVisibilty;

  event({
    required this.title,
    required this.description,
    this.image,
    this.eventType,
    required this.starterDate,
    required this.endDate,
    required this.starterTime,
    required this.endTime,
    this.field,
    required this.creationDate,
    this.location,
    required this.acceptsParticapants,
    required this.eventVisibilty,
    this.room,
    this.targetedAudiance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Image.network(
            image.toString(),
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.black12.withOpacity(.9),
              Colors.black12.withOpacity(.4)
            ])),
          ),
          Column(
            children: [
              Text(//need internet to test this //TODO add the other properties
                title,
                style: conHeadingsStyle.copyWith(fontSize: 15),
              ),
              Text(
                starterDate.toUtc().toString(),
                style: conHeadingsStyle.copyWith(fontSize: 15),
              )
            ],
          )
        ],
      ),
    );
  }
}

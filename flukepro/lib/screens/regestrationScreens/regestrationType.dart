import 'package:flukepro/screens/regestrationScreens/visitorRegestrationScreen.dart';
import 'package:flutter/material.dart';

import '../../components/cons.dart';
import '../../components/customWidgets.dart';
class regestrationTypeScreen extends StatelessWidget {

int? UserType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Column(
        children: [ SizedBox(
        height: MediaQuery.of(context).size.height / 8,
      ),
        Align(alignment: Alignment.centerRight,
          child: Container(margin: EdgeInsets.only(right: 65),
            child: Text(
              'هل ترغب في التسجيل كـ',
              textAlign: TextAlign.center,
              style: conHeadingsStyle
            ),
          ),
        ),SizedBox(
          height: 60,
        ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround
              ,children: [InkWell(onTap:  (){Navigator.pushNamed(context, VisitorRegistration.routeName, arguments: {0},);},
                child: Column(
                  children: [ Container(
                    width: 150,height: 160,
              child: Image.asset('images/The Little Things StandingCard.png'),
              decoration:BoxDecoration(border: Border.all(color: conBlack),borderRadius: BorderRadius.circular(25)) ,
                  ),
                    Text('زائر',style: TextStyle(fontSize: 17,fontFamily: 'Cairo',color: conBlack,fontWeight: FontWeight.bold),
                    )],
                ),),
                InkWell( onTap:  (){Navigator.pushNamed(context, VisitorRegistration.routeName, arguments: {1},);},//Organizers
                  child: Column(
                  children: [
                    Container(width: 150,height: 160,
              child: Image.asset('images/The Little Things Home Officecard.png'),
              decoration:BoxDecoration(border: Border.all(color: conBlack),borderRadius: BorderRadius.circular(25))
                      ,),
                    Text('جهة منظمة',style: TextStyle(fontSize: 17,fontFamily: 'Cairo',color: conBlack,fontWeight: FontWeight.bold)
                      ,),
                  ],
                ),),
              ],),
          SizedBox(height: 15,),
          InkWell(onTap: (){Navigator.pushNamed(context, VisitorRegistration.routeName, arguments: {2},);},//participants
            child: Column(
            children: [Container(margin: EdgeInsets.only(left: 10),width: 150,height: 160,
    child: Image.asset('images/The Little Things Working.png'),
    decoration:BoxDecoration(border: Border.all(color: conBlack),borderRadius: BorderRadius.circular(25)) ,),
              Text('مشارك',style: TextStyle(fontSize: 17,fontFamily: 'Cairo',color: conBlack,fontWeight: FontWeight.bold),)],),
          )],
        ),
      ),],),);
  }
}

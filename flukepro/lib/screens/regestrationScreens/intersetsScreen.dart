import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';

class interestsSelection extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(margin: EdgeInsets.only(top:   MediaQuery.of(context).size.height / 10,),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              children: [Text('شاركنا بمجالك أو المجال \nالذي يهمك',textAlign: TextAlign.right,style: conHeadingsStyle,),
                Text('لنوفر لك تجربة استخدام افضل',textDirection: TextDirection.rtl,textAlign: TextAlign.right,style: conOnboardingText.copyWith(color: conBlack),),
              ],
            ),
          ),
        ),
      ),);
  }
}

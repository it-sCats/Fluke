import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';
import 'package:concentric_transition/concentric_transition.dart';

class onBoarding extends StatelessWidget {
  List<dynamic> pages = [
    //هنا عبارة على خريطة فيها امتداد الصور والنص الخاص بكل صقحة باش يتم العرض منها والانتقال من صفحة لصفحة بالإندكس
    {
      'image': 'images/The Little Things Standing.png',
      'text': 'إبقى على إطلاع بكل الأحداث \nالتي تهمك وتفتح لك \nآفاق واسعة',
    },
    {
      'image': 'images/Group 55.png',
      'text': 'شارك في الأحداث و أضمن أن تصل \nخدماتك للفئة المستهدفة '
    },
    {
      'image': 'images/The Little Things Home Office.png',
      'text': 'نظم أحداث تحقق أهدافها \nبأدوات وبيانات فعالة'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: ConcentricPageView(
        //هذي الودجت متاع الباكج فيها عدة خصائص نتحكمو بيها للحصول على أونبروردينق كيف مانبو
        colors: <Color>[
          Color(0xff3f72be),
          Color(0xffF4742F),
          Color(0xff70CFCF)
        ],
        itemCount: 3, // null = infinity
        radius: 40, //قطر الدائرة
        verticalPosition: .85, //موقع الدائرة في الشاشة
        physics: NeverScrollableScrollPhysics(), //prevents scrolling
        onFinish: () {
          Navigator.pushNamed(context, '/log');
        },
        itemBuilder: (index) {
          //item bulder to build as many pages or widgets and controll the content by index
          int pageIndex = (index % pages.length);
          return Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height /
                    7), //a percentage to fit whith the rest of images in the right place
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  pages[pageIndex]['image'],
                  height: 400,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  pages[pageIndex]['text'],
                  textAlign: TextAlign.center,
                  style: conOnboardingText,
                )
              ],
            ),
          );
        },
      )),
    );
  }
}

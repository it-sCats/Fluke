import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';

import '../../components/customWidgets.dart';


class particepantRegistrationScreen extends StatelessWidget {
  final _particapantFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,//prevents keyboard from creating the error of overflowing
      backgroundColor: Colors.white,
      body: Form(
        key: _particapantFormKey,//this key to unique each form so when we validate it does the work
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            Align(alignment: Alignment.centerRight,
              child: Container(margin: EdgeInsets.only(right: 65),
                child: Text(
                  ' سجل كـجهة مشاركة ',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: conBlack,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: Container(
                    height: 55,
                    width: 51,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xff383838),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        )),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white.withOpacity(1),
                      backgroundImage: AssetImage('images/image 1.png'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                InkWell(
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                          color: Color(0xff3F72BE).withOpacity(.9),
                          border: Border.all(
                            color: Color(0xff383838),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10,left: 17),
                            child: Text(
                              'سجل بإستخدام قوقل',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            height: 55,
                            width: 51,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Color(0xff383838),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(23),
                                )),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white.withOpacity(1),
                              backgroundImage: AssetImage('images/google-tile 1.png'),
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 55, right: 15),
                    child: new Divider(
                      color: conBlack.withOpacity(.6),
                      height: 4,
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Text(
                      'أو',
                      style: TextStyle(
                          fontFamily: 'Cairo', fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 50),
                    child: new Divider(
                      color: conBlack.withOpacity(.6),
                      height: 4,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            txtFeild('إسم المشارك أو الجهة',false,false,false),
            txtFeild('example@mail.com',false,true,false),
            txtFeild('كلمة المرور',true,false,false),//custom widgets take the text and if its password or not
            txtFeild('طبيعة نشاط الفرد أو الجهة',false,false,false),
            txtFeild('حجم الشركة أو الأعمال, كبيرة متوسطةأو صغيرة',false,false,false),

            SizedBox(height: 20 ,),
            CTA('تسجيل ',(){if (_particapantFormKey.currentState!.validate()) {
              // If the form is valid, display a snackbar. In the real world,
              // you'd often call a server or save the information in a database.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Processing Data')),
              );
            }}),
            Row(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [ InkWell(
                  onTap: (){Navigator.pushNamed(context, '/log');},
                  child: Container(
                      margin: EdgeInsets.only(right:5,top: 5),
                      child: Text('قم بتسجيل دخول',textAlign: TextAlign.right,style:conTxtLink,))), InkWell(child: Container(margin: EdgeInsets.only(right:100,top: 10),
                  child: Text(' لديك حساب؟ ',textAlign: TextAlign.right,style: TextStyle(color:conBlack,fontFamily: 'Cairo',fontSize: 12,),))),],)
          ],
        ),
      ),
    );
  }
}

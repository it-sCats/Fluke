import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';

class loginScreen extends StatelessWidget {
  const loginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 8,
          ),
          Text(
            'تسجيل دخول ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: conBlack,
            ),
          ),
          SizedBox(
            height: 40,
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
                width: 17,
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
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'سجل دخول بإستخدام قوقل',
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
            height: 50,
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
            height: 36,
          ),
          SizedBox(
            width: 290,
            height: 60,
            child: TextFormField(
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 25),
                    hintText: 'إسم المستخدم',
                    hintStyle: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                    ),
                    enabledBorder: roundedTxtFeild,
                    focusedBorder: roundedTxtFeild)),
          ),
          TextFormField(),
          Text('data'),
          InkWell(
            child: Container(),
          ),
          Row()
        ],
      ),
    );
  }
}

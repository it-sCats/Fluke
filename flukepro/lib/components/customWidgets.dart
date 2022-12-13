import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'cons.dart';

//call to action buttons THE ORANGE BUTTON
class CTA extends StatelessWidget {
  CTA({required this.txt, required this.isFullwidth, required this.onTap});
  final String txt;
  final bool isFullwidth;
  Function onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        width: isFullwidth ? 290 : 145,
        height: 60,
        margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
        child: Text(
          txt,
          textAlign: TextAlign.center,
          style: conCTATxt,
        ),
        decoration: BoxDecoration(
          color: conORange,
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
      ),
    );
  }
}

class AgendaTextButton extends StatelessWidget {
  bool visibale = false;
  AgendaTextButton(
    this.visibale,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        'إنشاء أجندة ',
        style: conHeadingsStyle.copyWith(fontSize: 20),
      ),
    );
  }
}

//زر الاضافة في الداشبورد
class AddButton extends StatelessWidget {
  AddButton({
    required this.txt,
    required this.onTap,
  });
  final String txt;
  Function onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          width: defaultTargetPlatform == TargetPlatform.android ||
                  defaultTargetPlatform == TargetPlatform.iOS
              ? 85
              : 70,
          height: 85,
          margin: EdgeInsets.symmetric(
              vertical: size.height * 0.04, horizontal: size.width * 0.02),
          child: Text(
            txt,
            textAlign: TextAlign.center,
            style:
                conCTATxt.copyWith(fontSize: 37, fontWeight: FontWeight.w200),
          ),
          decoration: BoxDecoration(
            color: conORange,
            borderRadius: BorderRadius.all(
              Radius.circular(200),
            ),
          ),
        ),
      ),
    );
  }
}

//زر إضافة أجندة
class AddEventButton extends StatefulWidget {
  //
  AddEventButton(
      {required this.txt, required this.onTap, required this.showCreating});
  final String txt;
  Function onTap;
  bool showCreating;

  @override
  State<AddEventButton> createState() => _AddEventButtonState();
}

class _AddEventButtonState extends State<AddEventButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Visibility(
        visible: widget.showCreating,
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            width: defaultTargetPlatform == TargetPlatform.android ||
                    defaultTargetPlatform == TargetPlatform.iOS
                ? 100
                : 150,
            height: 40,
            padding: EdgeInsets.symmetric(vertical: 5),
            margin: EdgeInsets.symmetric(
                vertical: size.height * 0.090, horizontal: size.width * 0.080),
            child: InkWell(
              onTap: () => widget.onTap(),
              child: Text(
                widget.txt,
                textAlign: TextAlign.center,
                style: conCTATxt.copyWith(
                    fontSize: 13, fontWeight: FontWeight.w200),
              ),
            ),
            decoration: BoxDecoration(
              color: conORange.withOpacity(1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(0),
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
        ));
  }
}

class DiscartButton extends StatelessWidget {
//Todo make constructor for this with name and action
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        'إلغاء التغيرات',
        style: conTxtFeildHint.copyWith(color: Colors.blueGrey, fontSize: 13),
      ),
    );
  }
}

class CTA2 extends StatelessWidget {
  CTA2(this.txt, this.onTap);
  final String txt;
  Function onTap;

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        // margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
        width: 290,
        height: 70,
        child: Text(
          txt,
          textAlign: TextAlign.center,
          style: conCTATxt,
        ),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
      ),
    );
  }
}

//Txt feilds
class txtFeild extends StatefulWidget {
  txtFeild(this.txt, this.isPassword, this.isEmail, this.onchange, this.ontap,
      this.isDateTime, this.icon, this.readOnly, this.con);
  final String txt;
  Function onchange;
  Function ontap;
  bool readOnly;
  final bool isPassword;
  final bool isEmail;
  final bool isDateTime;
  final TextEditingController con;
  final Icon icon;

  @override
  State<txtFeild> createState() => _txtFeildState();
}

class _txtFeildState extends State<txtFeild> {
  late String _password;

  double _strength = 0;

  RegExp numReg = RegExp(r".*[0-9].*");

  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  String _displayText = 'كلمة المرور يجب أن تكون قوية ';
  FocusNode toSetLabel =
      new FocusNode(); //to set label for password it creates a var to see where is the focus

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 290,
      height: 70,
      child: TextFormField(
          controller: widget.con,
          style: TextStyle(fontSize: 15, fontFamily: 'Cairo', color: conBlack),
          focusNode: toSetLabel,
          onChanged: (value) => widget.onchange,
          onTap: () {
            widget.ontap();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال البيانات المطلوبة';
            }
            return null;
          },
          readOnly: widget.readOnly,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          keyboardType: widget.isEmail ? TextInputType.emailAddress : null,
          obscureText: widget.isPassword,
          decoration: conFieldDeco.copyWith(
              hintText: widget.txt, prefixIcon: widget.icon)),
    );
  }
}

//cancle button //used in userInfo and organizers requestd
class CancleButton extends StatelessWidget {
  CancleButton({required this.txt, required this.ontap});
  Function ontap;
  String txt;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ontap(),
      child: Text(
        txt,
        style: conTxtFeildHint.copyWith(color: Colors.blueGrey, fontSize: 13),
      ),
    );
  }
}

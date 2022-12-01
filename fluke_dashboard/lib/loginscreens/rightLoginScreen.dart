import 'package:flutter/material.dart';

class Right_LoginScreen extends StatelessWidget {
  Right_LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
      child: Padding(
        padding: const EdgeInsets.all(120.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: new Text(
                "اسمتع بالتجربة",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
            ),
            // Text(
            //   "سجل دخولك",
            //   textAlign: TextAlign.right,
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            // ),
            const SizedBox(
              height: 12,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: new Text("Fluke مرحبا بك في  "),
            ),
            // const Text(
            //   " Fluke مرحبا بك في ",
            //   style: TextStyle(fontSize: 12),
            //   textAlign: TextAlign.right,
            // ),
            const SizedBox(height: 24),
            TextFormField(
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                hintText: "الرجاء إدخال إسم المستخدم",
              ),
            ),
            const TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(hintText: "الرجاء إدخال الرمز"),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.topRight,
              child: MaterialButton(
                child: const Text("نسيت رمز المرور؟"),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 24),
            MaterialButton(
              onPressed: () {},
              child: Text("سجل دخولك"),
              minWidth: double.infinity,
              height: 52,
              elevation: 24,
              color: Color.fromARGB(255, 255, 170, 0),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
            )
          ],
        ),
      ),
    ));
  }
}

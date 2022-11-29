import 'package:flutter/material.dart';

class Rghit_LoginScreen extends StatelessWidget {
  Rghit_LoginScreen({Key? key}) : super(key: key);

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
            const Text(
              "Login",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              " Fluke مرحبا بك في ",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: InputDecoration(
                  label: Text("إسم المستخدم"),
                  hintText: "الرجاء إدخال إسم المستخدم"),
            ),
            const TextField(
              decoration: InputDecoration(
                  label: Text("الرمز"), hintText: "الرجاء إدخال الرمز"),
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
              color: Colors.amber.shade700,
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

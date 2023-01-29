import 'package:flukepro/components/cons.dart';
import 'package:flukepro/components/customWidgets.dart';
import 'package:flutter/material.dart';

class reportForm extends StatelessWidget {
  const reportForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                  )),
              Text(
                'الإبلاغ عن الحدث',
                style: conHeadingsStyle.copyWith(fontSize: 20),
              )
            ],
          ),
          Divider(),
          Text(
            'ما سبب البلاغ الذي تقدمه؟',
            style: conLittelTxt12,
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {},
                child: Text(
                  'يدعو للفساد أو التخريب ',
                  style: conHeadingsStyle.copyWith(
                      fontSize: 20, fontWeight: FontWeight.normal),
                ),
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'يحوي على كلام بذيء أو غير لائق',
                  style: conHeadingsStyle.copyWith(
                      fontSize: 20, fontWeight: FontWeight.normal),
                ),
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'حدث وهمي لاوجود له',
                  style: conHeadingsStyle.copyWith(
                      fontSize: 20, fontWeight: FontWeight.normal),
                ),
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'حدث غير أخلاقي أو عنصري',
                  style: conHeadingsStyle.copyWith(
                      fontSize: 20, fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
          lessEdgeCTA(txt: 'تقديم البلاغ', onTap: () {})
        ],
      ),
    );
  }
}

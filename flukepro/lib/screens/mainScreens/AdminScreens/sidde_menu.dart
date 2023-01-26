import 'package:flukepro/components/cons.dart';
import 'package:flukepro/screens/mainScreens/AdminScreens/loadData.dart';
import 'package:flutter/material.dart';

import 'package:flukepro/screens/OrganizersScreens/OHome.dart';

import 'displayDataPrev.dart';

int? pageIndex = 0;

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu>
    with SingleTickerProviderStateMixin {
  static List<Widget> _pages = [
    //بدل ما يتم توجيه المستخدم لصفحات مختلفة, بالطريقة هذه حيكون عندي ويدجيتس يتم التغيير بيناتهم عن طريق النافيقيشن سايد
    //هنا نتحكمو بالويدجيتس الي حينعرضو
    displaydataDashboardScreen(), //لوحة التحكم
    // Oprofile(), //الاحداث التي نظمها المنظم
    // OnotifiScreen(), //الاشعارات
    //الملف الشخصي متاعه
  ];
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("images/flukeLOGO.png"),
          ),
          DrawerListTile(
            title: "الرئيسية",
            Icond: Icons.view_compact_alt_rounded,

            //  Icond: Icons.manage_accounts_outlined,
            press: () {
              Navigator.pushNamed(context, '/log');
            },
          ),
          DrawerListTile(
            title: "المنظمين",
            Icond: Icons.co_present_rounded,
            press: () {},
          ),
          DrawerListTile(
            title: "الزوار",
            Icond: Icons.groups_rounded,
            press: () {},
          ),
          DrawerListTile(
            title: "المشاركين",
            // Icond: Icons.pan_tool_alt_sharp,
            Icond: Icons.sports_handball_sharp,
            press: () {},
          ),
          DrawerListTile(
            title: "الأحداث",
            Icond: Icons.event,
            press: () {},
          ),
          DrawerListTile(
            title: "بلاغات",
            Icond: Icons.report_problem_rounded,
            press: () {},
          ),
          DrawerListTile(
            title: "الحساب",
            Icond: Icons.account_circle,
            press: () {},
          ),
          DrawerListTile(
            title: "الضبط",
            Icond: Icons.settings_sharp,
            press: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.Icond,
    required this.press,
  }) : super(key: key);

  final String title;
  final Icond;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(
        Icond,
        color: Colors.white54,
        // height: 16,
      ),
      title: Text(
        title,
        style: conlabelsTxt,
      ),
    );
  }
}

Widget menuANavs(IconData icon, String text, Function callback,
    String currentPath, BuildContext context) {
  //ويدجيت خاصة بعناصر المينو
  return Padding(
    padding: EdgeInsets.all(10),
    child: InkWell(
        onTap: () => callback(),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: ModalRoute.of(context)!.settings.name == currentPath
                  ? Colors.white
                  : Colors.white.withOpacity(.5),
            ),
            SizedBox(width: 30),
            Text(
              text,
              style: conHeadingsStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ModalRoute.of(context)!.settings.name == currentPath
                      ? Colors.white
                      : Colors.white.withOpacity(.5)),
            )
          ],
        )),
  );
}

import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

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
            press: () {},
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

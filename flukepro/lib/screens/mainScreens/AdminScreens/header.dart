import 'package:flukepro/screens/mainScreens/AdminScreens/sidde_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/cons.dart';
import '../../../components/responsive.dart';
// import 'displayDataPrev.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: conBlue,
      child: Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: Row(
          children: [
            if (!Responsive.isDesktop(context))
              IconButton(
                  icon: Icon(Icons.menu),
                  //
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SideMenu(),
                        ));
                  }),
            if (!Responsive.isMobile(context))
              Text(
                "Dashboard",
              ),
            if (!Responsive.isMobile(context))
              Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
            // Expanded(child: SearchField()),
            ProfileCard()
          ],
        ),
      ),
    );
  }
}

class HeaderDataReport extends StatelessWidget {
  const HeaderDataReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: conBlue,
      child: Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: Row(
          children: [
            if (!Responsive.isDesktop(context))
              IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SideMenu(),
                        ));
                  }),
            if (!Responsive.isMobile(context))
              // Text(
              //   "Dashboard",
              //   style: Theme.of(context).textTheme.headline6,
              // ),
              if (!Responsive.isMobile(context))
                Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
            // Expanded(child: SearchField()),
            ProfileCard()
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: conBlue,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        // border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Image.asset(
            "images/profile_pic.png",
            height: 30,
          ),
          if (!Responsive.isMobile(context))
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: default_Padding / 2),
              child: Text("Fluke Admin"),
            ),
          // Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: conBlue,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            // child: Icon(),
          ),
        ),
      ),
    );
  }
}

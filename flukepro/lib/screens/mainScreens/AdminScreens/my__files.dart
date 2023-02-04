import 'package:flukepro/components/responsive.dart';
import 'package:flutter/material.dart';
import '../../../components/cons.dart';
import 'displayDataPrev.dart';
import 'main_screen.dart';

class MyFiles extends StatelessWidget {
  const MyFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Files",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
          ),
          tablet: FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  // final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: default_Padding,
      mainAxisSpacing: default_Padding,
      childAspectRatio: childAspectRatio,
      children: [
        InkWell(
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: conBlue,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Image.asset("images/visitors.png"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 0.8, left: 0.8, right: 0.8),
                  child: Text(
                    "الزوار",
                    style:
                        conHeadingsStyle.copyWith(color: white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Visitormainscreen(),
                ));
          },
        ),
        InkWell(
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: conBlue,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Image.asset("images/organizer.png"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 0.8, left: 0.8, right: 0.8),
                  child: Text(
                    "المنظمين",
                    style:
                        conHeadingsStyle.copyWith(color: white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrganizerMainScreen(),
                ));
          },
        ),
        InkWell(
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: conBlue,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Image.asset("images/Perticipants.png"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 0.8, left: 0.8, right: 0.8),
                  child: Text(
                    "المشاركين",
                    style:
                        conHeadingsStyle.copyWith(color: white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Particimainscreen(),
                ));
          },
        ),
        InkWell(
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: conBlue,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Image.asset("images/calendar.png"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 0.8, left: 0.8, right: 0.8),
                  child: Text(
                    " الأحداث",
                    style:
                        conHeadingsStyle.copyWith(color: white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Eventmainscreen(),
                ));
          },
        ),
        InkWell(
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: conBlue,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Image.asset("images/warning.png"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 0.8, left: 0.8, right: 0.8),
                  child: Text(
                    "البلاغات",
                    style:
                        conHeadingsStyle.copyWith(color: white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportsMainscreen(),
                ));
          },
        ),
      ],
    );
  }
}

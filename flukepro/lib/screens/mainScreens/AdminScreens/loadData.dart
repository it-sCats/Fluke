import 'package:flukepro/screens/mainScreens/AdminScreens/header.dart';
import 'package:flukepro/screens/mainScreens/AdminScreens/sidde_menu.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/appengine/v1.dart';
import 'package:googleapis/chromeuxreport/v1.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../components/cons.dart';
// import 'displayDataPrev.dart';
//https://react-native-firebase-testing.firebaseio.com

class LoadVisistorData extends StatelessWidget {
  const LoadVisistorData({super.key});

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            SizedBox(height: default_Padding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: SearchField()),
                Text(
                  "بيانات الزوار",
                  style: conlabelsTxt.copyWith(color: conBlack, fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: defaultPadding),
            Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('userType', isEqualTo: 0)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return LinearProgressIndicator();
                    } else {
                      print(snapshot.data!.docs[1].data());
                      return DataTable(
                          // border: TableBorder.all(),
                          border: TableBorder(
                            horizontalInside: BorderSide(
                                width: 1,
                                color: Colors.blue,
                                style: BorderStyle.solid),
                          ),
                          columns: [
                            DataColumn(
                                label: Text(
                              textAlign: TextAlign.end,
                              'الإهتمامات',
                              style: conlabelsTxt.copyWith(color: conBlack),
                            )),
                            DataColumn(
                                label: Text(
                              textAlign: TextAlign.end,
                              'الحساب',
                              style: conlabelsTxt.copyWith(color: conBlack),
                            )),
                            DataColumn(
                                label: Text(
                              textAlign: TextAlign.end,
                              'الإسم',
                              style: conlabelsTxt.copyWith(color: conBlack),
                            )),
                          ],
                          rows: _buildList(context, snapshot.data!.docs));
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot
        .map((data) =>
            _buildListItem(context, data.data() as Map<String, dynamic>))
        .toList();
  }

  DataRow _buildListItem(BuildContext context, Map<String, dynamic> data) {
    return DataRow(cells: [
      DataCell(Text(
        // textAlign: TextAlign.end,
        data['interests'].toString(),
        style: conlabelsTxt.copyWith(color: conBlack),
      )),
      DataCell(Text(
        textAlign: TextAlign.end,
        data['email'].toString(),
        style: conlabelsTxt.copyWith(color: conBlack),
      )),
      DataCell(Text(
        textAlign: TextAlign.end,
        data['name'].toString(),
        style: conlabelsTxt.copyWith(color: conBlack),
      )),
    ]);
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      generateDataloadList() async {
    var dataLoadList =
        await FirebaseFirestore.instance.collection('users').get();

    return dataLoadList.docs;
  }
}

//events
class LoadEventData extends StatelessWidget {
  const LoadEventData({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            SizedBox(height: default_Padding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: SearchField()),
                Text(
                  "بيانات الأحداث",
                  style: conlabelsTxt.copyWith(color: conBlack, fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: defaultPadding),
            Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('events')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return LinearProgressIndicator();
                    } else {
                      print(snapshot.data!.docs[1].data());
                      return DataTable(
                          // border: TableBorder.all(),
                          border: TableBorder(
                            horizontalInside: BorderSide(
                                width: 1,
                                color: Colors.blue,
                                style: BorderStyle.solid),
                          ),
                          columns: [
                            DataColumn(
                                label: Text(
                              textAlign: TextAlign.end,
                              'مجال الحدث',
                              style: conlabelsTxt.copyWith(color: conBlack),
                            )),
                            DataColumn(
                                label: Text(
                              textAlign: TextAlign.end,
                              'المدينة المقام بها الحدث',
                              style: conlabelsTxt.copyWith(color: conBlack),
                            )),
                            DataColumn(
                                label: Text(
                              textAlign: TextAlign.end,
                              'إسم الحدث',
                              style: conlabelsTxt.copyWith(color: conBlack),
                            )),
                          ],
                          rows: _buildList(context, snapshot.data!.docs));
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot
        .map((data) =>
            _buildListItem(context, data.data() as Map<String, dynamic>))
        .toList();
  }

  DataRow _buildListItem(BuildContext context, Map<String, dynamic> data) {
    return DataRow(cells: [
      DataCell(Text(
        // textAlign: TextAlign.end,
        data['field'].toString(),
        style: conlabelsTxt.copyWith(color: conBlack),
      )),
      DataCell(Text(
        textAlign: TextAlign.end,
        data['eventCity'].toString(),
        style: conlabelsTxt.copyWith(color: conBlack),
      )),
      DataCell(Text(
        textAlign: TextAlign.end,
        data['title'].toString(),
        style: conlabelsTxt.copyWith(color: conBlack),
      )),
    ]);
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      generateDataloadList() async {
    var dataLoadList =
        await FirebaseFirestore.instance.collection('events').get();

    return dataLoadList.docs;
  }
}

class LoadOrganizerData extends StatelessWidget {
  const LoadOrganizerData({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            SizedBox(height: default_Padding),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Expanded(child: SearchField()),
            //     Text(
            //       "بيانات المنظمين",
            //       style: conlabelsTxt.copyWith(color: conBlack, fontSize: 20),
            //     ),
            //   ],
            // ),
            SizedBox(height: defaultPadding),
            Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('events')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return LinearProgressIndicator();
                    } else {
                      print(snapshot.data!.docs[1].data());
                      return DataTable(
                          // border: TableBorder.all(),
                          border: TableBorder(
                            horizontalInside: BorderSide(
                                width: 1,
                                color: Colors.blue,
                                style: BorderStyle.solid),
                          ),
                          columns: [
                            DataColumn(
                                label: Text(
                              textAlign: TextAlign.end,
                              'مجال الحدث',
                              style: conlabelsTxt.copyWith(color: conBlack),
                            )),
                            DataColumn(
                                label: Text(
                              textAlign: TextAlign.end,
                              'المدينة المقام بها الحدث',
                              style: conlabelsTxt.copyWith(color: conBlack),
                            )),
                            DataColumn(
                                label: Text(
                              textAlign: TextAlign.end,
                              'إسم الحدث',
                              style: conlabelsTxt.copyWith(color: conBlack),
                            )),
                          ],
                          rows: _buildList(context, snapshot.data!.docs));
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot
        .map((data) =>
            _buildListItem(context, data.data() as Map<String, dynamic>))
        .toList();
  }

  DataRow _buildListItem(BuildContext context, Map<String, dynamic> data) {
    return DataRow(cells: [
      DataCell(Text(
        // textAlign: TextAlign.end,
        data['field'].toString(),
        style: conlabelsTxt.copyWith(color: conBlack),
      )),
      DataCell(Text(
        textAlign: TextAlign.end,
        data['eventCity'].toString(),
        style: conlabelsTxt.copyWith(color: conBlack),
      )),
      DataCell(Text(
        textAlign: TextAlign.end,
        data['title'].toString(),
        style: conlabelsTxt.copyWith(color: conBlack),
      )),
    ]);
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      generateDataloadList() async {
    var dataLoadList =
        await FirebaseFirestore.instance.collection('events').get();

    return dataLoadList.docs;
  }
}

class LoadReportsData extends StatelessWidget {
  const LoadReportsData({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

import 'package:flukepro/screens/mainScreens/AdminScreens/header.dart';
import 'package:flukepro/screens/mainScreens/AdminScreens/sidde_menu.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/appengine/v1.dart';
import 'package:googleapis/chromeuxreport/v1.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  // Future<DataloadGridSource> getDataloadGridSource() async {
  //   var dataLoadList = await generateDataloadList();
  //   return DataloadGridSource(dataLoadList);
  // }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridTextColumn(
          columnName: 'userID',
          width: 70,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: Text('User ID',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridTextColumn(
          columnName: 'name',
          width: 70,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child:
                  Text('name', overflow: TextOverflow.clip, softWrap: true))),
    ];
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      generateDataloadList() async {
    var dataLoadList =
        await FirebaseFirestore.instance.collection('users').get();
    // var response = await http
    //     .get(Uri.parse('https://react-native-firebase-testing.firebaseio.com'));
    // var dacodeData = json.decode(response.body).cast<Map<String, dynamic>>();
    // List<Data_load> dataLoadList = await dacodeData
    //     .map<Data_load>((json) => Data_load.fromJson(json))
    //     .toList();
    return dataLoadList.docs;
  }
}
//LoadVisistorData

class LoadData extends StatelessWidget {
  const LoadData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LinearProgressIndicator();
          } else {
            print(snapshot.data!.docs[1].data());
            return DataTable(columns: [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Votes')),
              DataColumn(label: Text('interests')),
            ], rows: _buildList(context, snapshot.data!.docs));
          }
        },
      ),
    ));
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
      DataCell(Text(data['name'].toString())),
      DataCell(Text(data['email'].toString())),
      DataCell(Text(data['email'].toString())),
      DataCell(Text(data['interests'].toString()))
    ]);
  }

  // Future<DataloadGridSource> getDataloadGridSource() async {
  //   var dataLoadList = await generateDataloadList();
  //   return DataloadGridSource(dataLoadList);
  // }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridTextColumn(
          columnName: 'userID',
          width: 70,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: Text('User ID',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridTextColumn(
          columnName: 'name',
          width: 70,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child:
                  Text('name', overflow: TextOverflow.clip, softWrap: true))),
    ];
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      generateDataloadList() async {
    var dataLoadList =
        await FirebaseFirestore.instance.collection('users').get();
    // var response = await http
    //     .get(Uri.parse('https://react-native-firebase-testing.firebaseio.com'));
    // var dacodeData = json.decode(response.body).cast<Map<String, dynamic>>();
    // List<Data_load> dataLoadList = await dacodeData
    //     .map<Data_load>((json) => Data_load.fromJson(json))
    //     .toList();
    return dataLoadList.docs;
  }
}

class DataloadGridSource extends DataGridSource {
  DataloadGridSource(this.dataLoadList) {
    buildDataGridRow();
  }
  late List<DataGridRow> dataGridRows;
  late List<Data_load> dataLoadList;
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        child: Text(row.getCells()[0].value.toString(),
            overflow: TextOverflow.ellipsis),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[1].value.toString(),
            overflow: TextOverflow.ellipsis),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
      ),
    ]);
  }

  @override
  // TODO: implement rows
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = dataLoadList.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'userID', value: dataGridRow.userId),
      ]);
    }).toList(growable: false);
  }
}

class Data_load {
  factory Data_load.fromJson(Map<String, dynamic> json) {
    return Data_load(
      userId: json['userID'],
      userName: json['name'],
    );
  }
  Data_load({
    required this.userId,
    required this.userName,
  });
  final int? userId;
  final String? userName;
}
// interests: json['interests'],
// events: json['events'],
// field: json['field'],
// userPhone: json['phone'],
// city: json['ShipName'],
// userbirthday: DateTime.parse(json['OrderDate']),
// final DateTime? orderDate;
// required interests,
// required userPhone,
// required field,
// required events
// required city,
// required userbirthday,
// required userType,
// required email,
// userType: json['userType'],
// email: json['email'],

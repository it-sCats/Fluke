import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoadData extends StatelessWidget {
  const LoadData({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: getDataloadGridSource(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return snapshot.hasData
                ? SfDataGrid(source: snapshot.data, columns: getColumns())
                : Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  );
          },
        ),
      ),
    );
  }

  Future<DataloadGridSource> getDataloadGridSource() async {
    var dataLoadList = await generateDataloadList();
    return DataloadGridSource(dataLoadList);
  }

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

  Future<List<Data_load>> generateDataloadList() async {
    var response = await http
        .get(Uri.parse('https://react-native-firebase-testing.firebaseio.com'));
    var dacodeData = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Data_load> dataLoadList = await dacodeData
        .map<Data_load>((json) => Data_load.fromJson(json))
        .toList();
    return dataLoadList;
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

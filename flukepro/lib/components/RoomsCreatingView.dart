import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';

class RoomsView extends StatefulWidget {
  const RoomsView({Key? key}) : super(key: key);

  @override
  State<RoomsView> createState() => _RoomsViewState();
}

class _RoomsViewState extends State<RoomsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _addTile(),
        Container(width: 200, child: roomsFields()),
      ],
    );
  }

  List<TextEditingController> _controllers = [];
  List<TextField> _fields = [];

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _addTile() {
    return Container(
      decoration: BoxDecoration(
          color: conORange,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      width: 180,
      child: ListTile(
        title: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
        onTap: () {
          final controller = TextEditingController();
          final field = TextField(
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                hintText: "القاعة ${_controllers.length + 1}",
                hintStyle: conTxtFeildHint,
                filled: true,
                fillColor: Color(0xffF1F1F1),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10))),
          );

          setState(() {
            _controllers.add(controller);
            _fields.add(field);
          });
        },
      ),
    );
  }

  Widget roomsFields() {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: _fields.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(10),
            child: _fields[index],
          );
        },
      ),
    );
  }
}

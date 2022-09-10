import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyPickerPage extends StatefulWidget {
  @override
  _MyPickerPageState createState() => _MyPickerPageState();
}

class _MyPickerPageState extends State<MyPickerPage> {
  DateTime selectedDate = DateTime.now();
  TextEditingController _date = new TextEditingController();
  TextEditingController _date2 = new TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        var date1 = DateTime.parse(picked.toString());
        String formattedDate = DateFormat('yyyy-MM-dd').format(date1);

        _date.value = TextEditingValue(text: formattedDate);
      });
  }

  Future<Null> _selectDate2(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        var date2 = DateTime.parse(picked.toString());
        String formattedDate = DateFormat('yyyy-MM-dd').format(date2);
        selectedDate = picked;
        _date2.value = TextEditingValue(text: formattedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          color: Colors.red,
          height: 100,
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _date,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintText: '2018-02-03',
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _selectDate2(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _date2,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintText: '2018-02-03',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

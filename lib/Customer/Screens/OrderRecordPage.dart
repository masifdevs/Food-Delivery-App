import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:month_picker_strip/month_picker_strip.dart';
import 'package:practiceapp/Constants.dart';
import 'package:practiceapp/Customer/Models/OrderDetail.dart';

class View_Purchase extends StatefulWidget {
  final User_id;
  View_Purchase({this.User_id});

  @override
  _View_PurchaseState createState() => _View_PurchaseState();
}

class _View_PurchaseState extends State<View_Purchase> {
  String _verticalGroupValue;
  List<String> _Display_Method = ["By Date", "By Month"];
  String Purchasedate = "";
  String Date = "";
  DateTime selectedMonth = DateTime.now();
  List<String> Prod_name = [];
  List<OrdersDetail> orderdataitem = List();
  @override
  void initState() {
    _verticalGroupValue = _Display_Method[0];

    super.initState();
  }

  Future _Show_Details() async {
    var response;
    if (_verticalGroupValue == _Display_Method[0]) {
      response =
          await http.post(Order_Api_Address + "fetch_order-by-date.php", body: {
        'user': widget.User_id.toString(),
        "order_date": Purchasedate.toString(),
      });
    } else {
      DateTime last = DateTime(selectedMonth.year, selectedMonth.month + 1);
      var initialdate = DateFormat('yyyy-MM-dd').format(selectedMonth);
      var lastdate = DateFormat('yyyy-MM-dd').format(last);

      response =
          await http.post(Order_Api_Address + "fetch_order_monthly.php", body: {
        'user': widget.User_id.toString(),
        "initial_date": initialdate.toString(),
        "last_date": lastdate.toString(),
      });
    }
    orderdataitem = (json.decode(response.body) as List)
        .map((data) => new OrdersDetail.fromJson(data))
        .toList();
    return orderdataitem;
  }

  int selected;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Purchase Detail"),
        ),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Show :",
                  style: TextStyle(fontSize: 20, color: Colors.blue[800]),
                ),
                RadioGroup<String>.builder(
                  direction: Axis.horizontal,
                  groupValue: _verticalGroupValue,
                  onChanged: (value) => setState(() {
                    _verticalGroupValue = value;
                    Purchasedate = "";

                    if (value == _Display_Method[1]) {
                      selectedMonth = DateTime.now()
                          .subtract(Duration(days: DateTime.now().day - 1));
                    } else {
                      selectedMonth = DateTime.now();
                    }
                  }),
                  items: _Display_Method,
                  itemBuilder: (item) => RadioButtonBuilder(
                    item,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _verticalGroupValue == _Display_Method[0]
                ? Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: RaisedButton(
                      color: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Pick Date',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        DateTime date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now().subtract(Duration(days: 30)),
                          lastDate: DateTime.now(),
                        );
                        setState(() {
                          var date2 = DateTime.parse(date.toString());
                          Purchasedate = DateFormat('yyyy-MM-dd').format(date2);
                        });
//              print("Time Picekd = ${Purchasedate}");
                      },
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue[800], width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: MonthStrip(
                      format: 'MMM yyyy',
                      from: DateTime.now().subtract(Duration(days: 366)),
                      to: DateTime.now(),
                      initialMonth: selectedMonth,
                      height: 48.0,
                      normalTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      selectedTextStyle: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      viewportFraction: 0.25,
                      onMonthChanged: (v) {
                        setState(() {
                          selectedMonth = v;
                          print("Selected Month = ${selectedMonth.month}");
                        });
                      },
                    )),
            SizedBox(
              height: 10,
            ),
            Purchasedate != "" || _verticalGroupValue == _Display_Method[1]
                ? Expanded(
                    child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue[800], width: 3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FutureBuilder(
                            future: _Show_Details(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    OrdersDetail item = snapshot.data[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Card(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 8.0),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    item.name,
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    "Price : ${item.price}",
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 15.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    "items : ${item.qty}",
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    item.date,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}",
                                    style:
                                        Theme.of(context).textTheme.headline);
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            })),
                  )
                : SizedBox(),
          ],
        ),
      );
}

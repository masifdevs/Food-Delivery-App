import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_strip/month_picker_strip.dart';
import 'package:practiceapp/Constants.dart';
import 'package:practiceapp/Customer/Models/Orders.dart';
import 'package:practiceapp/Customer/Models/user_model.dart';
import 'package:practiceapp/Customer/Widgets/spending.dart';

class Account extends StatefulWidget {
  String User_id;
  Account({this.User_id});
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  DateTime date = DateTime.now();
  var formatteddate;
  // final DateFormat dateFormat = new DateFormat('MMMM yyyy');
  DateTime selectedMonth;
  @override
  void initState() {
    selectedMonth = new DateTime.now();
    formatteddate = DateFormat('yyyy-MM').format(selectedMonth);
    var user = widget.User_id;
    print(formatteddate);
    _fetchMonthlyData(formatteddate, user);
    super.initState();
  }

  List<OrderItem> neworderdata = List();
  Widget _monthpiceker() {
    return new MonthStrip(
      format: 'MMM yyyy',
      from: new DateTime(2019, 1),
      to: new DateTime.now(),
      initialMonth: selectedMonth,
      height: 48.0,
      viewportFraction: 0.25,
      onMonthChanged: (v) {
        setState(() {
          selectedMonth = v;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    formatteddate = DateFormat('yyyy-MM').format(selectedMonth);
    print(formatteddate);
    var user = widget.User_id;
    _fetchMonthlyData(formatteddate, user);
    return Scaffold(
        body: SafeArea(
            child: Column(children: <Widget>[
      Container(
        height: MediaQuery.of(context).size.height / 2.8,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                _buildDesignContainer(context),
              ],
            ),
            _buildGridContainer(context),
          ],
        ),
      ),
      Expanded(
          child: Column(
        children: <Widget>[
          Center(
              child: Text(
            'Your Purchase History',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
          Expanded(
            child: ListView.builder(
                itemCount: 3,
                itemBuilder: (BuildContext ctx, int indx) {
                  return Text(neworderdata.length.toString());
                }),
          )
        ],
      ))
    ])));
  }

  Widget _buildGridContainer(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: new EdgeInsets.only(
          top: MediaQuery.of(context).size.height * .18,
          right: 20.0,
          left: 20.0),
      child: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GridView(
          primary: false,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 2.5),
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child: Spendings(
                name: "Total Bill",
                amount: "PKR 1290.0",
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              child: Spendings(
                name: "Total Orders ",
                amount: " 20",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesignContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.2, 0.7],
          colors: [
            Color(0xFF0F0E21),
            Color(0xFF1D1E33),
          ],
        ),
      ),
      height: MediaQuery.of(context).size.height * .30,
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            color: Colors.white,
            child: _monthpiceker(),
          ),
          SizedBox(height: 10),
          Text(
            "Total Purchase",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Rs 14000",
            style: TextStyle(
                color: Colors.white,
                fontSize: 34.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future _fetchMonthlyData(mdate, user) async {
    print("$mdate ---$user");
    String url = Api_Address + 'Customer_Apis/monthdata.php';
    final response = await http.post(url, body: {
      'date': mdate.toString(),
      'user': widget.User_id.toString(),
    });

    if (response.statusCode == 200) {
      // var datauser = json.decode(response.body);
      // if (datauser.length == 0) {
      //   print("no-------------");
      // } else {
      //   print('heello');
      // }
    } else {
      throw Exception('Failed to load Category');
    }
  }
}

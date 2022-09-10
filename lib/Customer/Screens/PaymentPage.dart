import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:practiceapp/Constants.dart';
import 'package:practiceapp/Customer/Models/Customer_Bill.dart';
import 'package:practiceapp/Customer/Widgets/MoveableTopPics.dart';
import 'package:practiceapp/Customer/Widgets/spending.dart';
import 'package:practiceapp/Customer/services/payment_service.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  final u_id;
  PaymentPage({this.u_id});
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController _numbercontroller = TextEditingController();
  bool isLoading;
  String id;
  List<Bill_pay> bill_list = List();
  @override
  void initState() {
    id = widget.u_id;
    _fetchbill();
    StripeService.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Page"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(children: <Widget>[
          Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3.4,
                    child: _buildDesignContainer(context),
                  ),
                ],
              ),
              Padding(
                padding: new EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .20, bottom: 15),
                child: Container(
                  margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  height: 100,
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: bill_list.length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = bill_list[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Spendings(
                                    name: "Total Bill",
                                    amount: "Rs ${data.price}"),
                                Spendings(
                                    name: "Balance",
                                    amount: "Rs ${data.balance}"),
                              ],
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30.0, right: 30, bottom: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Enter Price',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 5,
                              color: Colors.red,
                            ))),
                    controller: _numbercontroller,
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30.0, right: 30, bottom: 20),
                  child: GestureDetector(
                    onTap: () {
                      String billprice = (_numbercontroller.text).toString();
                      _numbercontroller.clear();
                      onItemPress(billprice);
                    },
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                        child: Text(
                          "Pay via VISA Card",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      )),
    );
  }

  Widget _buildDesignContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
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
      child: MoveableTopPics(),
    );
  }

  Future _fetchbill() async {
    setState(() {
      isLoading = false;
    });

    DateTime now = DateTime.now();
    String date = DateFormat('yyyy-MM-dd').format(now);

    String url = Api_Address + 'fetch_customer_bill.php';

    final response = await http.post(url, body: {
      'c_id': id.toString(),
      'date': date.toString(),
    }).timeout(Duration(seconds: 20));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      bill_list = (json.decode(response.body) as List)
          .map((data) => new Bill_pay.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load bill');
    }
    return bill_list;
  }

  void onItemPress(String billprice) async {
    final ProgressDialog pr = ProgressDialog(context);
    pr.style(message: 'please wait...');
    await pr.show();
    //change here
    StripeTransactionResponse response = await StripeService.payFromNewCard(
        '${(int.parse(billprice) * 100).toString()}',
        'USD'); // 15000 mean 150.00 dollar

    await pr.hide();
    if (response.message == 'transaction successful') {
      _payBill(billprice);
      Fluttertoast.showToast(
        backgroundColor: Colors.grey[600],
        gravity: ToastGravity.BOTTOM,
        msg: "transaction successful",
      );
    } else if (response.message == 'Transaction cancelled') {
      Fluttertoast.showToast(
        backgroundColor: Colors.grey[600],
        gravity: ToastGravity.BOTTOM,
        msg: "Transaction cancelled",
      );
    } else if (response.message == 'transaction failed') {
      Fluttertoast.showToast(
        backgroundColor: Colors.grey[600],
        gravity: ToastGravity.BOTTOM,
        msg: "transaction failed",
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.grey[600],
        gravity: ToastGravity.BOTTOM,
        msg: "${response.message}",
      );
    }
  }

  _payBill(String bill) async {
    DateTime now = DateTime.now();
    String date = DateFormat('yyyy-MM-dd').format(now);
    String url = Api_Address + 'pay_bill_monthly.php';
    final response = await http.post(url, body: {
      'c_id': id.toString(),
      'date': date.toString(),
      'pay_amount': bill.toString(),
    });

    if (response.statusCode == 200) {
      var data = response.body;
      print(data);
      _fetchbill();
    } else {
      throw Exception('Failed to Pay Bill');
    }
  }
}

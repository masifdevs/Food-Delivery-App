import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practiceapp/Constants.dart';

class Payment_Page extends StatefulWidget {
  Payment_Page({Key key}) : super(key: key);

  @override
  _Payment_PageState createState() => _Payment_PageState();
}

class _Payment_PageState extends State<Payment_Page> {
  Timer _timer;

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  TextEditingController firstNameInputController;
  TextEditingController priceInputController;
  TextEditingController cnicInputController;

  clearTextInput() {
    priceInputController.clear();
    firstNameInputController.clear();
    cnicInputController.clear();
  }

  @override
  initState() {
    firstNameInputController = new TextEditingController();
    priceInputController = new TextEditingController();
    cnicInputController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Customer Bill")),
        body: Center(
          child: Container(
              child: SingleChildScrollView(
                  child: Form(
                      key: _registerFormKey,
                      child: Column(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, bottom: 20),
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: 'CNIC number'),
                                    controller: cnicInputController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      new LengthLimitingTextInputFormatter(13),
                                    ],
                                    validator: cnicValidator,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Customer Name'),
                                    controller: firstNameInputController,
                                    validator: nameValidator,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: 'Payment Price'),
                                    controller: priceInputController,
                                    validator: priceValidator,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () {
                              if (_registerFormKey.currentState.validate()) {
                                var name = firstNameInputController.text;
                                var price = priceInputController.text;
                                var cnic = cnicInputController.text;

                                print("$name $cnic $price");
                                pay_customerbill(name, cnic, price);
                                clearTextInput();
                              }
                            },
                            child: Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                  color: Colors.blue[800],
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Center(
                                child: Text(
                                  "Pay Bill",
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
                      ])))),
        ));
  }

  String nameValidator(String value) {
    Pattern pattern = r'^[A-Za-z]+(?:[ _-][A-Za-z0-9]+)*$';

    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Customer Name format is invalid';
    } else if (value.length < 3) {
      return 'Customer Name is invalid';
    } else {
      return null;
    }
  }

  String cnicValidator(String value) {
    Pattern pattern = r'^[0-9]+(?:[ _-][A-Za-z0-9]+)*$';

    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'CNIC format is invalid';
    } else if (value.length < 11) {
      return 'CNIC invalid';
    } else {
      return null;
    }
  }

  String priceValidator(String value) {
    Pattern pattern = r'^[0-9]+(?:[ _-][A-Za-z0-9]+)*$';

    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Price format is invalid';
    } else if (value.length < 3) {
      return 'Price invalid';
    } else {
      return null;
    }
  }

  pay_customerbill(name, cnic, price) async {
    DateTime now = DateTime.now();
    String date = DateFormat('yyyy-MM-dd').format(now);

    String url = Api_Address + 'deliveryboy_pay_bill.php';

    final response = await http.post(url, body: {
      'user': name.toString(),
      'cnic': cnic.toString(),
      'pay_amount': price.toString(),
      'date': date.toString(),
    }).timeout(Duration(seconds: 20));

    if (response.statusCode == 200) {
      var message = json.decode(response.body);
      if (message == '') {
        Fluttertoast.showToast(
          backgroundColor: Colors.blue[800],
          gravity: ToastGravity.TOP,
          msg: "No User Found",
        );
      } else {
        Fluttertoast.showToast(
          backgroundColor: Colors.blue[800],
          gravity: ToastGravity.TOP,
          msg: message,
        );
        _pop_outscreen();
      }
    } else {
      throw Exception('Failed to Create Account');
    }
  }

  _pop_outscreen() {
    _timer = new Timer(const Duration(milliseconds: 700), () {
      setState(() {
        Navigator.of(context).pop();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}

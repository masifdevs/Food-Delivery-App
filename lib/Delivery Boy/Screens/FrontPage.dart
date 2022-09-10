import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:practiceapp/Constants.dart';
import 'package:practiceapp/Delivery%20Boy/Screens/Delivey_boy_location.dart';
import 'package:practiceapp/Customer/Widgets/home_page_custom_shape.dart';
import 'package:practiceapp/Delivery%20Boy/Screens/CustomerOrder.dart';
import 'package:practiceapp/Delivery%20Boy/Screens/D_ProfilePage.dart';
import 'package:http/http.dart' as http;

class D_MainPage extends StatefulWidget {
  final password;
  final email;
  D_MainPage({this.email, this.password});

  @override
  _D_MainPageState createState() => _D_MainPageState();
}

class _D_MainPageState extends State<D_MainPage> {
  var id;
  @override
  void initState() {
    fetchuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        drawer: Drawer(
          child: D_ProfilePage(userid: id.toString()),
        ),
        appBar: AppBar(
          title: Text("Delivery Boy"),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              buildHeaderStack(),
              Expanded(child: FoodOrder(userid: id.toString())),
            ],
          ),
        ),
      ),
    );
  }

  Stack buildHeaderStack() {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue[900],
                  Colors.blue[600],
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Current Orders",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future fetchuser() async {
    String url = Api_Address + 'fetch_user_Id.php';
    final response = await http.post(url, body: {
      'email': widget.email.toString(),
      'password': widget.password.toString()
    });

    if (response.statusCode == 200) {
      id = jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Category');
    }
  }
}

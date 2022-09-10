import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:practiceapp/Constants.dart';
import 'package:practiceapp/Customer/Models/Deliveryboy_location.dart';
import 'package:practiceapp/Customer/Models/user_model.dart';
import 'package:practiceapp/Customer/Screens/ChangePassword.dart';
import 'package:practiceapp/Customer/Screens/NotificationsPage.dart';
import 'package:practiceapp/Delivery%20Boy/Screens/PayBillPage.dart';
import 'package:practiceapp/Customer/Screens/locationPage.dart';
import 'package:practiceapp/Delivery%20Boy/Screens/Delivey_boy_location.dart';
import 'package:practiceapp/Customer/Screens/Order.dart';
import 'package:practiceapp/Customer/Screens/OrderRecordPage.dart';
import 'package:practiceapp/Customer/Screens/PaymentPage.dart';
import 'package:practiceapp/Customer/Widgets/Accounts.dart';
import 'package:practiceapp/Customer/Widgets/custom_list_tile.dart';
import 'package:practiceapp/SignIn_Page.dart';

class ProfilePage extends StatefulWidget {
  final userid;
  ProfilePage({this.userid});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<User> userdata = List();
  Timer _timer;
  List<DeliverBoy> d_location = List();
  bool isLoading = false;
  Future fetchuser(String id) async {
    setState(() {
      isLoading = true;
    });

    String url = Api_Address + 'fetch_user with_id.php';
    final response = await http.post(url,
        body: {'user_id': id.toString()}).timeout(Duration(seconds: 25));

    if (response.statusCode == 200) {
      userdata = (json.decode(response.body) as List)
          .map((data) => new User.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  _getlocation() async {
    String url = Api_Address + 'fetch_deliveryboy_location.php';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      d_location = (json.decode(response.body) as List)
          .map((data) => new DeliverBoy.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load Data');
    }
  }

  String name;
  String address;
  double lng;
  double lat;
  @override
  void initState() {
    fetchuser(widget.userid);
    _getlocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.blue[900],
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "User Profile",
                        style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        height: 110,
                        child: _userinfo(),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.popAndPushNamed(context, 'C-home');
                      },
                      child: ListTile(
                          leading: Icon(Icons.home), title: Text("Home")),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                View_Purchase(User_id: widget.userid)));
                      },
                      child: ListTile(
                          leading: Icon(Icons.receipt), title: Text("History")),
                    ),
                    GestureDetector(
                      onTap: () {
                        _timer =
                            new Timer(const Duration(milliseconds: 500), () {
                          lat = d_location[0].lat;
                          lng = d_location[0].lng;
                          name = d_location[0].username;
                          address = d_location[0].address;
                        });
                        new Timer(const Duration(milliseconds: 500), () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OrderScreen(
                                  Uid: widget.userid,
                                  lng: lng,
                                  lat: lat,
                                  address: address,
                                  name: name)));
                        });
                      },
                      child: ListTile(
                          leading: Icon(Icons.shopping_cart),
                          title: Text("Current Orders")),
                    ),
                    Divider(
                      color: Colors.grey[300],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NotificationsPage()));
                      },
                      child: ListTile(
                          leading: Icon(Icons.notifications),
                          title: Text("Notifications")),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChangePasswordPage()));
                      },
                      child: ListTile(
                          leading: Icon(Icons.lock),
                          title: Text("Change Password")),
                    ),
                    Divider(
                      color: Colors.grey[200],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                PaymentPage(u_id: widget.userid)));
                      },
                      child: ListTile(
                          leading: Icon(Icons.payment), title: Text("Payment")),
                    ),
                    GestureDetector(
                      onTap: () {
                        _exitApp(context);
                      },
                      child: ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text(
                          "Log Out",
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userinfo() {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: userdata.length,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Text(
                  userdata[index].username.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.phone,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      userdata[index].phone,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.email,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      userdata[index].email,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  Future<bool> _exitApp(BuildContext context) {
    return showDialog(
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text('Do you want to exit this application?'),
          content: Text('We hate to see you leave...'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'No',
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false);
              },
              child: Text(
                'Yes',
              ),
            ),
          ],
        ));
  }
}

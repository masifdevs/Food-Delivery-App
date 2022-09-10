import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:practiceapp/Constants.dart';
import 'package:practiceapp/Customer/Models/user_model.dart';
import 'package:practiceapp/Customer/Screens/ChangePassword.dart';
import 'package:practiceapp/Delivery%20Boy/Screens/PayBillPage.dart';
import 'package:practiceapp/Delivery%20Boy/Screens/Delivey_boy_location.dart';
import 'package:practiceapp/Delivery%20Boy/Screens/DeliveryHistoryPage.dart';
import 'package:practiceapp/Delivery%20Boy/Screens/Notifications.dart';
import 'package:practiceapp/SignIn_Page.dart';

class D_ProfilePage extends StatefulWidget {
  final userid;
  D_ProfilePage({this.userid});
  @override
  _D_ProfilePageState createState() => _D_ProfilePageState();
}

class _D_ProfilePageState extends State<D_ProfilePage> {
  List<User> userdata = List();
  bool isLoading = false;
  Future fetchuser(String id) async {
    setState(() {
      isLoading = true;
    });

    String url = Api_Address + 'fetch_user with_id.php';
    final response = await http.post(url,
        body: {'user_id': id.toString()}).timeout(Duration(seconds: 20));

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

  @override
  void initState() {
    fetchuser(widget.userid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.blue[800],
              height: 150,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 50,
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
                      Navigator.popAndPushNamed(context, 'D-home');
                    },
                    child: ListTile(
                        leading: Icon(Icons.home), title: Text("Home")),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              DeliveryHistoryPage(User_id: widget.userid)));
                    },
                    child: ListTile(
                        leading: Icon(Icons.receipt), title: Text("History")),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => D_NotificationsPage()));
                    },
                    child: ListTile(
                        leading: Icon(Icons.notifications),
                        title: Text("Notifications")),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Payment_Page()));
                    },
                    child: ListTile(
                        leading: Icon(Icons.payment),
                        title: Text("Pay Customer Bill")),
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
              children: <Widget>[
                Text(
                  userdata[index].username.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
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

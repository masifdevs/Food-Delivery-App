import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:practiceapp/Constants.dart';
import 'package:practiceapp/Customer/Models/Notifications.dart';

class D_NotificationsPage extends StatefulWidget {
  @override
  _D_NotificationsPageState createState() => _D_NotificationsPageState();
}

class _D_NotificationsPageState extends State<D_NotificationsPage> {
  List<CustomerNotification> noti_list = List();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    _fetchNotification();
  }

  var formatter = new DateFormat('dd-MM-yyyy');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: ListView.builder(
                  itemCount: noti_list.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    var data = noti_list[index];
                    var now = DateTime.parse(data.date);

                    String formattedDate = formatter.format(now);
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        elevation: 4.0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 15.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    data.title,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(formattedDate)
                                ],
                              ),
                              Divider(
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 5.0),
                              Text(data.description)
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
    );
  }

  _fetchNotification() async {
    setState(() {
      isLoading = true;
    });

    String url = Delivery_boy_Appi + "Notification.php";

    try {
      var result = await http.get(url);

      if (result.statusCode == 200) {
        noti_list = (json.decode(result.body) as List)
            .map((data) => new CustomerNotification.fromJson(data))
            .toList();
        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load Notification');
      }
    } catch (e) {
      print("\n---exception catch here--$e");
    }
  }
}

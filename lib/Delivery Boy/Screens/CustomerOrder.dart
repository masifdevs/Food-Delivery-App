import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practiceapp/Constants.dart';
import 'package:practiceapp/Delivery%20Boy/Screens/Delivey_boy_location.dart';
import 'package:practiceapp/Delivery%20Boy/Models/CustomerModel.dart';
import 'package:geolocator/geolocator.dart' hide LocationAccuracy;

class FoodOrder extends StatefulWidget {
  final userid;
  FoodOrder({this.userid});

  @override
  _FoodOrderState createState() => _FoodOrderState();
}

class _FoodOrderState extends State<FoodOrder> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  String _currentAddress;
  var d_latitude;
  var d_longitude;
  var currentLocation;
  List<Customer> user_data = List();
  var isLoading;

  @override
  void initState() {
    getUserLocation();
    _getAddressFromLatLng();
    _fetchdata();

    super.initState();
  }

  @override
  void dispose() {
    print("dispose");
    _updatelocation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const fiveSeconds = const Duration(seconds: 30);
    // // // _fetchData() is your function to fetch data
    Timer.periodic(fiveSeconds, (Timer t) => _updatelocation());

    _updatelocation();
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            padding: EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: user_data.length,
                itemBuilder: (ctx, indx) {
                  var user = user_data[indx];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyMapApp(
                                  id: user.orderno,
                                  name: user.username,
                                  address: user.address,
                                  lon: user.lng,
                                  lat: user.lat,
                                  d_lat: d_latitude,
                                  d_long: d_longitude)));
                    },
                    child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 4.0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Order No : ${user.orderno}",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Divider(
                                color: Colors.grey[300],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.account_box,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    user.username,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _fooddeliver(user.orderno,
                                            widget.userid, user.customer_id);
                                        user_data.removeAt(indx);
                                      });
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          color: Colors.blue[400],
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: Center(child: Text("Delivered")),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.phone,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    user.phone_nmbr,
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _ordercancel(user.orderno);
                                        user_data.removeAt(indx);
                                      });
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          color: Colors.red[300],
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child:
                                          Center(child: Text("Not Delivered")),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Text(
                                user.address,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        )),
                  );
                }),
          );
  }

  _fooddeliver(String orderno, String d_id, String c_id) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formattedtime = DateFormat('HH:mm:ss').format(now);

    String url = Delivery_boy_Appi + 'updatefood_delivered.php';
    final response = await http.post(url, body: {
      'id': orderno.toString(),
      'd_id': d_id.toString(),
      'c_id': c_id.toString(),
      'sp_date': formattedDate.toString(),
      'sp_time': formattedtime.toString(),
    });

    if (response.statusCode == 200) {
      var data = response.body;
      Fluttertoast.showToast(
        backgroundColor: Colors.blue[800],
        gravity: ToastGravity.TOP,
        msg: "$data",
      );
    } else {
      throw Exception('Failed to load Category');
    }
  }

  Future<Position> locateUser() async {
    return Geolocator().getCurrentPosition();
  }

  getUserLocation() async {
    currentLocation = await locateUser();
    d_longitude = currentLocation.longitude;
    d_latitude = currentLocation.latitude;

    _getAddressFromLatLng();
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          currentLocation.latitude, currentLocation.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress = "${place.subLocality} " +
            "${place.locality} " +
            "${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  _fetchdata() async {
    setState(() {
      isLoading = true;
    });
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    String url = Delivery_boy_Appi + 'get_Customers_Order.php';
    final response = await http.post(url,
        body: ({
          "date": formattedDate.toString(),
        }));

    if (response.statusCode == 200) {
      user_data = (json.decode(response.body) as List)
          .map((data) => new Customer.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load Data');
    }
  }

  _updatelocation() async {
    String url = Api_Address + 'update_location.php';
    final response = await http.post(url,
        body: ({
          'lng': d_longitude.toString(),
          'lat': d_latitude.toString(),
          'address': _currentAddress.toString(),
          'user_id': (widget.userid).toString(),
        }));

    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load Data');
    }
  }

  _ordercancel(String orderno) async {
    String url = Customer_Appi + 'Cancel_order.php';
    final response = await http.post(url, body: {
      'o_id': orderno.toString(),
    });

    if (response.statusCode == 200) {
      var data = response.body;

      Fluttertoast.showToast(
        backgroundColor: Colors.blue[800],
        gravity: ToastGravity.TOP,
        msg: "$data",
      );
    } else {
      throw Exception('Failed to Cancel Order');
    }
  }
}

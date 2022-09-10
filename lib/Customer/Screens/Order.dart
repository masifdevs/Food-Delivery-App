import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practiceapp/Constants.dart';
import 'package:practiceapp/Customer/Models/Deliveryboy_location.dart';
import 'package:practiceapp/Customer/Models/OrderDetail.dart';
import 'package:practiceapp/Customer/Models/Orders.dart';
import 'package:practiceapp/Customer/Widgets/OrdersDetail.dart';
import 'package:practiceapp/Customer/Screens/locationPage.dart';

class OrderScreen extends StatefulWidget {
  final Uid;
  final name;
  final lng;
  final lat;
  final address;
  OrderScreen({this.Uid, this.address, this.lng, this.lat, this.name});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<OrderItem> orderdata = List();
  var date;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  double lat;
  double lng;
  String name;
  String address;
  var isLoading;
  Future fetchuser(String id, date) async {
    setState(() {
      isLoading = true;
    });

    String url = Order_Api_Address + 'fetch_current_order.php';

    final response = await http.post(url, body: {
      'user': id.toString(),
      'date': date.toString(),
    });

    if (response.statusCode == 200) {
      orderdata = (json.decode(response.body) as List)
          .map((data) => new OrderItem.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load Data');
    }
  }

  List<DeliverBoy> d_location = List();
  Completer<GoogleMapController> _controller = Completer();
  // BitmapDescriptor myIcon;

  static LatLng _lat1 = LatLng(30.1575, 71.5249);

  MapType _currentMapType = MapType.normal;
  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    date = dateFormat.format(DateTime.now());

    fetchuser(widget.Uid, date);
    lng = widget.lng;
    lat = widget.lat;
    name = widget.name;
    address = widget.address;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders '),
        ),
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.red,
              height: 250,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat, lng),
                  zoom: 11.0,
                ),
                mapType: _currentMapType,
                markers: {
                  Marker(
                    markerId: MarkerId(
                      LatLng(lat, lng).toString(),
                    ),
                    position: LatLng(lat, lng),
                    infoWindow: InfoWindow(title: name, snippet: address),
                    icon: BitmapDescriptor.defaultMarker,
                  ),
                },
              ),
            ),
            isLoading
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: orderdata.length,
                          itemBuilder: (ctx, indx) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (buildcontext) =>
                                        OrderDetail(id: orderdata[indx].id)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
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
                                              "Order No: ${orderdata[indx].id}",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text("${orderdata[indx].time}")
                                          ],
                                        ),
                                        SizedBox(height: 15.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Total Bill :  Rs.${orderdata[indx].bill}",
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              "${orderdata[indx].date}",
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _ordercancel(
                                                      orderdata[indx].id);
                                                  orderdata.removeAt(indx);
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 18.0,
                                                          right: 18,
                                                          top: 8,
                                                          bottom: 8),
                                                  child: Text("Cancel"),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
          ],
        ));
  }

  _ordercancel(String orderno) async {
    String url = Customer_Appi + 'Cancel_order.php';
    final response = await http.post(url, body: {
      'o_id': orderno.toString(),
    });

    if (response.statusCode == 200) {
      var data = response.body;
      print(data);
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

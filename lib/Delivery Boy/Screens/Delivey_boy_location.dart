import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:practiceapp/Constants.dart';
import 'package:practiceapp/Customer/Models/OrderDetail.dart';
import 'package:http/http.dart' as http;

class MyMapApp extends StatefulWidget {
  final lon;
  final id;
  final lat;
  final name;
  final address;
  final d_long;
  final d_lat;
  MyMapApp(
      {this.id,
      this.name,
      this.address,
      this.lon,
      this.lat,
      this.d_lat,
      this.d_long});
  @override
  _MyMapAppState createState() => _MyMapAppState();
}

class _MyMapAppState extends State<MyMapApp> {
  bool isLoading = false;
  List<OrdersDetail> order_data = List();

  Completer<GoogleMapController> _controller = Completer();
  var c_latitude;
  var c_longitude;
  var d_latitude;
  var d_longitude;
  String name;
  String address;
  var currentLocation;
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
    super.initState();
    name = widget.name;
    address = widget.address;
    print(widget.lon);
    print(widget.lat);
    print(widget.d_long);
    print(widget.d_lat);
    c_latitude = widget.lon;
    c_longitude = widget.lat;
    d_latitude = widget.d_long;
    d_longitude = widget.d_lat;
    _fooddetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order No : ${widget.id}"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 300,
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      d_longitude,
                      d_latitude,
                    ),
                    zoom: 11.0,
                  ),
                  mapType: _currentMapType,
                  markers: {
                    Marker(
                      markerId: MarkerId(
                        LatLng(c_longitude, c_latitude).toString(),
                      ),
                      position: LatLng(c_longitude, c_latitude),
                      infoWindow: InfoWindow(title: name, snippet: address),
                      icon: BitmapDescriptor.defaultMarker,
                    ),
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      children: <Widget>[
                        FloatingActionButton(
                          onPressed: _onMapTypeButtonPressed,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: Colors.green,
                          child: const Icon(Icons.map, size: 36.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue[800], width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        itemCount: order_data.length,
                        itemBuilder: (buildcontext, int indx) {
                          var data = order_data[indx];
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              elevation: 4.0,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Item : ${data.name}",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("Qty : ${data.qty}"),
                                          Text("Price : ${data.price}"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }

  _fooddetail(String orderno) async {
    setState(() {
      isLoading = true;
    });

    String url = Delivery_boy_Appi + 'get_Customer_Order_Detail.php';
    final response = await http.post(url, body: {
      'o_id': orderno.toString(),
    });

    if (response.statusCode == 200) {
      order_data = (json.decode(response.body) as List)
          .map((data) => new OrdersDetail.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load Category');
    }
  }
}

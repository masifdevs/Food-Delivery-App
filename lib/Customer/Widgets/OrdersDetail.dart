import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practiceapp/Constants.dart';
import 'package:practiceapp/Customer/Models/OrderDetail.dart';

class OrderDetail extends StatefulWidget {
  String id;
  OrderDetail({this.id});

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  List<OrdersDetail> orderdataitem = List();
  bool isLoading = false;
  Future fetchdata(String id) async {
    setState(() {
      isLoading = true;
    });

    String url = Api_Address + 'Order_Apis/current_order_detail.php';
    final response = await http.post(url, body: {
      'order_id': id.toString(),
    });

    if (response.statusCode == 200) {
      orderdataitem = (json.decode(response.body) as List)
          .map((data) => new OrdersDetail.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load Category');
    }
  }

  @override
  void initState() {
    fetchdata(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order No ${widget.id}"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue[900], width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        //
        child: Container(
          child: ListView.builder(
            itemCount: orderdataitem.length,
            itemBuilder: (buildcontext, int indx) {
              var data = orderdataitem[indx];
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 5),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  elevation: 4.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              data.name,
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                            Text("items : ${data.qty}"),
                            Text("price : ${data.price}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

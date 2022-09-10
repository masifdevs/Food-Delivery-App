import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:practiceapp/Constants.dart';
import 'package:practiceapp/Customer/Providers/cartmodel.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CartPageState();
  }
}

class _CartPageState extends State<CartPage> {
  var id, title, qty, price, date, time, totalbill, userid, bill;
  List<String> p_name = [];
  List<String> p_id = [];
  List<String> p_qty = [];
  List<String> p_price = [];

  void createAlbum(String userid, String bill) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formattedtime = DateFormat('HH:mm:ss').format(now);
    print("$p_name -- $p_qty --Your Bill is : $bill");

    String url = Order_Api_Address + 'Order_detail_api.php';
    try {
      final response = await http.post(url,
          body: ({
            "Order": json.encode([
              {
                "product_name": p_name,
                "product_id": p_id,
                "qty": p_qty,
                "amount": p_price,
                "date": formattedDate.toString(),
                "time": formattedtime.toString(),
                "bill_price": bill.toString(),
                "userid": userid.toString(),
              }
            ])
          }));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          backgroundColor: Colors.blue[800],
          gravity: ToastGravity.TOP,
          msg: "Sucessfully Order",
        );
      } else {
        throw Exception('Failed to load Category');
      }
    } catch (e) {
      print("Erro is $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final newCart = Provider.of<CartModel>(context);
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.indigo,
            title: Text("Your Cart"),
            actions: <Widget>[
              FlatButton(
                  child: Text(
                    "Clear",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => newCart.clearCart())
            ]),
        body: newCart.cart.length == 0
            ? _buildTopContainer(context)
            : Container(
                padding: EdgeInsets.all(8.0),
                child: Column(children: <Widget>[
                  Expanded(
                      child: ListView.builder(
                    itemCount: newCart.cart.length,
                    itemBuilder: (context, index) {
                      Uint8List bytes =
                          base64Decode(newCart.cart[index].imgUrl);
                      var P_img = MemoryImage(bytes);

                      return GestureDetector(
                        onLongPress: () {
                          newCart.removeProduct(newCart.cart[index]);
                        },
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 4.0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: P_img, fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(30.0),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.white,
                                            blurRadius: 5.0,
                                            offset: Offset(0.0, 2.0))
                                      ]),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        newCart.cart[index].title,
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      "${newCart.cart[index].qty} * ${newCart.cart[index].price.toInt()} = ${(newCart.cart[index].qty * newCart.cart[index].price)}",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  margin: EdgeInsets.only(top: 35),
                                  height: 30,
                                  color: Colors.grey[200],
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: <Widget>[
                                        InkWell(
                                          child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child:
                                                  Icon(Icons.remove, size: 15)),
                                          onTap: () {
                                            print("cart data");
                                            newCart.updateProduct(
                                                newCart.cart[index],
                                                newCart.cart[index].qty - 1);
                                            // model.removeProduct(model.cart[index]);
                                          },
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                            newCart.cart[index].qty.toString()),
                                        SizedBox(width: 5),
                                        InkWell(
                                          child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: Icon(
                                                Icons.add,
                                                size: 15,
                                              )),
                                          onTap: () {
                                            newCart.updateProduct(
                                                newCart.cart[index],
                                                newCart.cart[index].qty + 1);
                                            // model.removeProduct(model.cart[index]);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )),
                  Container(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Total Bill :",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            'Rs ${newCart.totalCartValue.toString()}',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                  GestureDetector(
                    onTap: () {
                      for (int i = 0; i < newCart.cart.length; i++) {
                        p_id.add(newCart.cart[i].id.toString());
                        p_name.add(newCart.cart[i].title.toString());
                        p_qty.add(newCart.cart[i].qty.toString());
                        p_price.add(newCart.cart[i].price.toString());
                      }
                      bill = newCart.totalCartValue.toString();
                      createAlbum(newCart.user, bill);

                      newCart.clearCart();
                    },
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                          color: Colors.blue[900],
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Center(
                        child: Text(
                          'Order Now!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ])));
  }

  Widget _buildTopContainer(BuildContext context) {
    return Center(
      child: Text("There are no items in this Cart"),
    );
  }
}

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:practiceapp/Constants.dart';
import 'package:practiceapp/Customer/Models/product.dart';
import 'package:practiceapp/Customer/Providers/cartmodel.dart';
import 'package:practiceapp/Customer/Screens/cartpage.dart';
import 'package:provider/provider.dart';

class ProductdetailPage extends StatefulWidget {
  final List clist;
  final int index;
  ProductdetailPage({this.clist, this.index});

  @override
  _ProductdetailPageState createState() => _ProductdetailPageState();
}

class _ProductdetailPageState extends State<ProductdetailPage> {
  List<Product> plist = List();

  var isLoading = false;

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    String url = Product_Api_Address + 'get_Product_withId_Apis.php';
    final response = await http.post(url, body: {
      "id": ((widget.clist[widget.index].id).toString()),
    });
    if (response.statusCode == 200) {
      plist = (json.decode(response.body) as List)
          .map((data) => new Product.fromJson(data))
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
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myproductsData = Provider.of<CartModel>(context);
    return Scaffold(
        appBar: AppBar(
            title: Text("${widget.clist[widget.index].name}"),
            backgroundColor: Colors.indigo,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CartPage())),
              )
            ]),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Scrollbar(
                child: Container(
                    child: ListView.builder(
                        itemCount: plist.length,
                        itemBuilder: (context, index) {
                          Uint8List bytes = base64Decode(plist[index].imgUrl);
                          var P_img = MemoryImage(bytes);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: new Stack(
                                  children: <Widget>[
                                    new Container(
                                      height: 170,
                                      width: MediaQuery.of(context).size.width,
                                      child: Image(
                                          image: P_img, fit: BoxFit.cover),
                                    ),
                                    new Positioned(
                                      left: 0.0,
                                      bottom: 0.0,
                                      child: new Container(
                                        height: 50.0,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                          colors: [
                                            Colors.red,
                                            Colors.white,
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        )),
                                      ),
                                    ),
                                    Positioned(
                                      left: 10.0,
                                      bottom: 5.0,
                                      right: 10.0,
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    plist[index].title,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "Price : ",
                                                      ),
                                                      Text("Rs " +
                                                          plist[index]
                                                              .price
                                                              .toString()),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                myproductsData
                                                    .addProduct(plist[index]);
                                                final snackBar = SnackBar(
                                                  content: Text(
                                                      '${plist[index].title.toUpperCase()} Added To Cart'),
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                );
                                                Scaffold.of(context)
                                                    .showSnackBar(snackBar);
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 130,
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                              child: Center(
                                                child: Text(
                                                  "Add to Cart",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
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
                        })),
              ));
  }
}

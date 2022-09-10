// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:practiceapp/Constants.dart';
// import 'package:practiceapp/Customer/Models/Category.dart';
// import 'package:practiceapp/Customer/Models/product.dart';
// import 'package:practiceapp/Customer/Providers/cartmodel.dart';
// import 'package:provider/provider.dart';

// class NewCat extends StatefulWidget {
//   @override
//   _NewCatState createState() => _NewCatState();
// }

// class _NewCatState extends State<NewCat> {
//   List<Category> clist = List();
//   var isLoading = false;

//   _fetchCategoryData() async {
//     setState(() {
//       isLoading = true;
//     });
//     final response =
//         await http.get(Category_Api_Address + "get_Category_Api.php");
//     if (response.statusCode == 200) {
//       clist = (json.decode(response.body) as List)
//           .map((data) => new Category.fromJson(data))
//           .toList();
//       setState(() {
//         isLoading = false;
//       });
//     } else {
//       throw Exception('Failed to load Category');
//     }
//   }

//   // ----------------------------

//   List<Product> pdlist = List();
//   Future fetchPost([int]) async {
//     String url = Product_Api_Address + "get_Product_withId_Apis.php";
//     final response = await http.post(url, body: {
//       "id": ((int).toString()),
//     });

//     if (response.statusCode == 200) {
//       pdlist = (json.decode(response.body) as List)
//           .map((data) => new Product.fromJson(data))
//           .toList();
//       setState(() {
//         isLoading = false;
//       });
//     } else {
//       throw Exception('Failed to load Category');
//     }
//   }

//   @override
//   void initState() {
//     _fetchCategoryData();

//     fetchPost(1);

//     super.initState();
//   }

//   int catid = 1;
//   var title = '';

//   @override
//   Widget build(BuildContext context) {
//     final productsData = Provider.of<CartModel>(context);
//     return Scaffold(
//       appBar: AppBar(title: Text(title), actions: <Widget>[
//         IconButton(
//           icon: Icon(
//             Icons.shopping_cart,
//             size: 30,
//           ),
//           onPressed: () => Navigator.pushNamed(context, '/cart'),
//         ),
//       ]),
//       body: SafeArea(
//         child: Row(
//           children: <Widget>[
//             isLoading
//                 ? Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 : Container(
//                     width: MediaQuery.of(context).size.width * 0.22,
//                     child: Container(
//                         margin: EdgeInsets.all(5),
//                         child: ListView.builder(
//                             itemCount: clist.length,
//                             itemBuilder: (context, index) {
//                               return GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     title = clist[index].name;
//                                     catid = clist[index].id;
//                                     fetchPost(catid);
//                                   });
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(4.0),
//                                   child: Column(
//                                     children: <Widget>[
//                                       ClipOval(
//                                         child: Container(
//                                             height: 40.0,
//                                             width: 40.0,
//                                             child: Image.network(
//                                                 clist[index].imageUrl,
//                                                 fit: BoxFit.cover)),
//                                       ),
//                                       SizedBox(
//                                         height: 7,
//                                       ),
//                                       Text(
//                                         clist[index].name,
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             })),
//                   ),
//             isLoading
//                 ? Center(
//                     child: Container(
//                         margin: EdgeInsets.only(left: 150.0),
//                         child: CircularProgressIndicator()),
//                   )
//                 : Container(
//                     color: Colors.grey[200],
//                     width: MediaQuery.of(context).size.width * 0.78,
//                     child: Container(
//                         margin: EdgeInsets.all(5),
//                         child: ListView.builder(
//                             itemCount: pdlist.length,
//                             itemBuilder: (context, index) {
//                               Uint8List bytes =
//                                   base64Decode(pdlist[index].imgUrl);
//                               var Pimg = MemoryImage(bytes);

//                               return Padding(
//                                 padding: const EdgeInsets.all(6.0),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   child: new Stack(
//                                     children: <Widget>[
//                                       new Container(
//                                         height: 150,
//                                         width:
//                                             MediaQuery.of(context).size.width,
//                                         child: Image(
//                                             image: Pimg, fit: BoxFit.cover),
//                                       ),
//                                       new Positioned(
//                                         left: 0.0,
//                                         bottom: 0.0,
//                                         child: new Container(
//                                           height: 35.0,
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           decoration: BoxDecoration(
//                                               gradient: LinearGradient(
//                                             colors: [Colors.red, Colors.white],
//                                             begin: Alignment.bottomCenter,
//                                             end: Alignment.topCenter,
//                                           )),
//                                         ),
//                                       ),
//                                       Positioned(
//                                         left: 10.0,
//                                         bottom: 10.0,
//                                         child: new Row(
//                                           children: <Widget>[
//                                             Text(pdlist[index].title),
//                                             SizedBox(
//                                               width: 10,
//                                             ),
//                                             Text(
//                                                 "Rs : ${pdlist[index].price.toString()}"),
//                                             SizedBox(
//                                               width: 30,
//                                             ),
//                                             GestureDetector(
//                                                 onTap: () {
//                                                   productsData.addProduct(
//                                                       pdlist[index]);
//                                                   final snackBar = SnackBar(
//                                                     content: Text(
//                                                         '${pdlist[index].title.toUpperCase()} Added To Cart'),
//                                                     duration: Duration(
//                                                         milliseconds: 500),
//                                                   );
//                                                   Scaffold.of(context)
//                                                       .showSnackBar(snackBar);
//                                                 },
//                                                 child: Icon(
//                                                   Icons.add_circle,
//                                                   color: Colors.green,
//                                                   size: 20,
//                                                 )),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             })),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }

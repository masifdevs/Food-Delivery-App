// // Stack buildHeaderStack() {
// //     return Stack(
// //       children: <Widget>[
// //         Container(
// //           height: 60,
// //           width: MediaQuery.of(context).size.width,
// //           color: Colors.blue[800],
// //           child: Center(
// //             child: Container(
// //               height: 40,
// //               width: MediaQuery.of(context).size.width * 0.9,
// //               alignment: Alignment.bottomCenter,
// //               decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.all(Radius.circular(10))),
// //               child: TextField(
// //                 onChanged: (value) {
// //                   filterSearchResults(value);
// //                 },
// //                 controller: searchController,
// //                 decoration: InputDecoration(
// //                     focusedBorder: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(10.0),
// //                       borderSide: BorderSide(color: Colors.white, width: 1.0),
// //                     ),
// //                     enabledBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(10.0),
// //                         borderSide: BorderSide(
// //                           color: Colors.white,
// //                           width: 1.0,
// //                         )),
// //                     hintText: "Search",
// //                     hintStyle: TextStyle(fontSize: 18),
// //                     contentPadding: EdgeInsets.only(top: 5),
// //                     prefixIcon:
// //                         Icon(Icons.search, color: Colors.black54, size: 20)),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
//  Center(
//             child: Text(
//           "Just For You",
//           style: TextStyle(fontSize: 20),
//         )),
//         Expanded(
//             child: isLoading
//                 ? Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 : Container(
//                     child: ListView.builder(
//                         itemCount: plist.length,
//                         itemBuilder: (context, index) {
//                           Uint8List bytes = base64Decode(plist[index].imgUrl);
//                           var P_img = MemoryImage(bytes);
//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(15.0),
//                                 child: new Stack(
//                                   children: <Widget>[
//                                     new Container(
//                                       height: 170,
//                                       width: MediaQuery.of(context).size.width,
//                                       child: Image(
//                                           image: P_img, fit: BoxFit.cover),
//                                     ),
//                                     new Positioned(
//                                       left: 0.0,
//                                       bottom: 0.0,
//                                       child: new Container(
//                                         height: 50.0,
//                                         width:
//                                             MediaQuery.of(context).size.width,
//                                         decoration: BoxDecoration(
//                                             gradient: LinearGradient(
//                                           colors: [
//                                             Colors.red,
//                                             Colors.white,
//                                           ],
//                                           begin: Alignment.bottomCenter,
//                                           end: Alignment.topCenter,
//                                         )),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       left: 10.0,
//                                       bottom: 5.0,
//                                       right: 10.0,
//                                       child: new Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: <Widget>[
//                                           Row(
//                                             children: <Widget>[
//                                               Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.center,
//                                                 children: <Widget>[
//                                                   Text(
//                                                     plist[index].title,
//                                                     style: TextStyle(
//                                                         fontSize: 18,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   ),
//                                                   SizedBox(
//                                                     height: 5.0,
//                                                   ),
//                                                   Row(
//                                                     children: <Widget>[
//                                                       Text(
//                                                         "Price : ",
//                                                       ),
//                                                       Text("\$" +
//                                                           plist[index]
//                                                               .price
//                                                               .toString()),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                           InkWell(
//                                             onTap: () {
//                                               setState(() {
//                                                 productsData
//                                                     .addProduct(plist[index]);
//                                                 final snackBar = SnackBar(
//                                                   content: Text(
//                                                       '${plist[index].title.toUpperCase()} Added To Cart'),
//                                                   duration: Duration(
//                                                       milliseconds: 500),
//                                                 );
//                                                 Scaffold.of(context)
//                                                     .showSnackBar(snackBar);
//                                               });
//                                             },
//                                             child: Container(
//                                               height: 30,
//                                               width: 70,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.green,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           8.0)),
//                                               child: Center(
//                                                 child: Text(
//                                                   "Order",
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         }))),
      

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:practiceapp/Constants.dart';
import 'package:practiceapp/Customer/Models/category.dart';
import 'package:practiceapp/Customer/Widgets/productDetail.dart';

class CSidePage extends StatefulWidget {
  @override
  _CSidePageState createState() => _CSidePageState();
}

class _CSidePageState extends State<CSidePage> {
  List<Category> clist = List();
  var isLoading = false;

  _fetchCategoryData() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Api_Address + "Product_Apis/get_Product_withId_Apis.php");
    if (response.statusCode == 200) {
      clist = (json.decode(response.body) as List)
          .map((data) => new Category.fromJson(data))
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
    _fetchCategoryData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: ListView.builder(
                  itemCount: clist.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductdetailPage(
                                      clist: clist,
                                      index: index,
                                    )));
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: SizedBox(
                            child: Column(
                          children: <Widget>[
                            ClipOval(
                              child: Container(
                                  height: 60.0,
                                  width: 60.0,
                                  child: Image.network(clist[index].imageUrl,
                                      fit: BoxFit.cover)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(clist[index].name)
                          ],
                        )),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practiceapp/Customer/Models/Product.dart';
import 'package:practiceapp/Customer/Models/category.dart';
import 'package:practiceapp/Customer/Widgets/productDetail.dart';
import 'dart:convert';
import '../../Constants.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Product> plist = List();
  bool isLoading = false;
  @override
  void initState() {
    _fetchCategoryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue[900], width: 3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: isLoadingdata
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  child: _categoryListView(),
                )),
    );
  }
  // -------------------Category -------------

  List<Category> clist = List();
  var isLoadingdata = false;
  _fetchCategoryData() async {
    setState(() {
      isLoadingdata = true;
    });
    final response =
        await http.get(Category_Api_Address + "get_Category_Api.php");

    if (response.statusCode == 200) {
      clist = (json.decode(response.body) as List)
          .map((data) => new Category.fromJson(data))
          .toList();
      setState(() {
        isLoadingdata = false;
      });
    } else {
      throw Exception('Failed to load Category');
    }
  }

// -------------------Category Widget ----------------------
  Widget _categoryListView() {
    return GridView.builder(
        itemCount: clist.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
        itemBuilder: (BuildContext context, int index) {
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
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  ClipOval(
                    child: Container(
                        height: 100.0,
                        width: 100.0,
                        child: Image.network(clist[index].imageUrl,
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    clist[index].name,
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
          );
        });
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:practiceapp/Customer/Models/product.dart';
import 'package:practiceapp/Customer/Providers/cartmodel.dart';
import 'package:practiceapp/Customer/Screens/MainPage.dart';
import 'package:practiceapp/Customer/Screens/cartpage.dart';
import 'package:practiceapp/Customer/Screens/profile_page.dart';
import 'package:practiceapp/Customer/Widgets/home_page_custom_shape.dart';
import 'package:provider/provider.dart';
import '../../Constants.dart';
import 'package:practiceapp/Constants.dart';

class C_MainPage extends StatefulWidget {
  final password;
  final email;
  C_MainPage({this.email, this.password});

  @override
  _C_MainPageState createState() => _C_MainPageState();
}

class _C_MainPageState extends State<C_MainPage> {
  var id;
  Timer _timer;
  @override
  void initState() {
    fetchuser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<CartModel>(context);
    productsData.user = id;

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        drawer: Drawer(child: ProfilePage(userid: id.toString())),
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                size: 30,
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => CartPage())),
            ),
          ],
          title: Text("Customer"),
        ),
        body: MainPage(),
      ),
    );
  }

// ----------------
  Future fetchuser() async {
    String url = Api_Address + 'fetch_user_Id.php';
    final response = await http.post(url, body: {
      'email': widget.email.toString(),
      'password': widget.password.toString()
    });

    if (response.statusCode == 200) {
      id = jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Category');
    }
  }

  // ----------------
  var isLoading = false;
}

import 'package:flutter/material.dart';
import 'package:practiceapp/Customer/Providers/cartmodel.dart';
import 'package:practiceapp/Customer/Screens/MainHomeScreen.dart';
import 'package:practiceapp/Customer/Screens/cartpage.dart';
import 'package:practiceapp/Delivery%20Boy/Screens/FrontPage.dart';
import 'package:practiceapp/SignIn_Page.dart';
import 'package:practiceapp/SignUp_Page.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: CartModel(),
          ),
        ],
        child: MaterialApp(
            theme: ThemeData(
              primaryColor: Colors.blue[900],
            ),
            debugShowCheckedModeBanner: false,
            home: LoginPage(),
            routes: {
               '/cart': (context) => CartPage(),
              '/register': (context) => SignUp_Page(),
              '/D-home': (context) => D_MainPage(),
              '/C-home': (context) => C_MainPage(),
            }));
  }
}

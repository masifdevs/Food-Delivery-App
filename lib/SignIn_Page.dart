import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:practiceapp/Constants.dart';
import 'package:practiceapp/Customer/Screens/MainHomeScreen.dart';
import 'package:practiceapp/Delivery%20Boy/Screens/FrontPage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool _toggleConfirmVisibility = true;
  var message;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  final focus = FocusNode();
  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  clearTextInput() {
    emailInputController.clear();
    pwdInputController.clear();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
              child: Form(
            key: _loginFormKey,
            child: Column(
              children: <Widget>[
                Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 20),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                          textInputAction: TextInputAction.next,
                          controller: emailInputController,
                          keyboardType: TextInputType.emailAddress,
                          validator: emailValidator,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focus);
                          },
                        ),
                        TextFormField(
                          focusNode: focus,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _toggleConfirmVisibility =
                                      !_toggleConfirmVisibility;
                                });
                              },
                              icon: _toggleConfirmVisibility
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                            ),
                          ),
                          obscureText: _toggleConfirmVisibility,
                          controller: pwdInputController,
                          validator: pwdValidator,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if (_loginFormKey.currentState.validate()) {
                      var email = emailInputController.text;
                      var password = pwdInputController.text;
// ============
                      var saltedPassword = salt + password;
                      var bytes = utf8.encode(saltedPassword);
                      var passhash = sha256.convert(bytes);
                      print("$email -- $passhash");
                      userLogin(email, passhash);
                      clearTextInput();
                    }
                  },
                  child: Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                        color: Colors.blue[800],
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Center(
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                          color: Color(0xFFBDC2CB),
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                    SizedBox(width: 10.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/register");
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ))),
    ));
  }

  userLogin(email, password) async {
    String url = Api_Address + "login_api.php";
    try {
      final response = await http.post(url, body: {
        'email': email.toString(),
        'password': password.toString()
      }).timeout(Duration(seconds: 20));

      if (response.statusCode == 200) {
        var datauser = json.decode(response.body);
        print(datauser);
        if (datauser == 'customer') {
          Fluttertoast.showToast(
            backgroundColor: Colors.blue[800],
            gravity: ToastGravity.TOP,
            msg: "Sucessfully login",
          );
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      C_MainPage(email: email, password: password)),
              (Route<dynamic> route) => false);
        } else if (datauser == 'delivery boy') {
          print('delivery boy');
          Fluttertoast.showToast(
            backgroundColor: Colors.blue[800],
            gravity: ToastGravity.TOP,
            msg: "Sucessfully login",
          );
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      D_MainPage(email: email, password: password)),
              (Route<dynamic> route) => false);
        }
      } else {
        Fluttertoast.showToast(
          backgroundColor: Colors.blue[800],
          gravity: ToastGravity.TOP,
          msg: "Invalid attempt",
        );
        throw Exception('Failed to load Category');
      }
    } catch (e) {
      _ackAlert(context);
      print("\n---exception catch here-- \n $e");
    }
  }

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text('Error ...!'),
          content: const Text('Some Thing going wrong !!!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:practiceapp/Constants.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage({Key key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool _toggleConfirmVisibility = true;
  bool _toggleConfirmVisibility1 = true;
  var message;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController newpwdInputController;
  final focus = FocusNode();
  final newpassfocus = FocusNode();
  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    newpwdInputController = new TextEditingController();
    super.initState();
  }

  clearTextInput() {
    emailInputController.clear();
    pwdInputController.clear();
    newpwdInputController.clear();
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
      appBar: AppBar(
        title: Text("Change Password"),
      ),
      body: Center(
          child: Container(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    children: <Widget>[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, bottom: 20),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                ),
                                textInputAction: TextInputAction.next,
                                controller: emailInputController,
                                keyboardType: TextInputType.emailAddress,
                                validator: emailValidator,
                              ),
                              TextFormField(
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
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'New Password',
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _toggleConfirmVisibility1 =
                                            !_toggleConfirmVisibility1;
                                      });
                                    },
                                    icon: _toggleConfirmVisibility1
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility),
                                  ),
                                ),
                                obscureText: _toggleConfirmVisibility1,
                                controller: newpwdInputController,
                                validator: pwdValidator,
                              ),
                              SizedBox(
                                height: 30,
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
                            var newpassword = newpwdInputController.text;
                            // ------
                            var saltedPassword = salt + password;
                            var bytes = utf8.encode(saltedPassword);
                            var passhash = sha256.convert(bytes);

                            var saltednewpass = salt + newpassword;
                            var cnicbytes = utf8.encode(saltednewpass);
                            var newpasshash = sha256.convert(cnicbytes);

                            clearTextInput();
                            userLogin(email, passhash, newpasshash);
                          }
                        },
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: Colors.blue[900],
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Center(
                            child: Text(
                              'Update Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }

  Future userLogin(email, password, newpassword) async {
    String url = Api_Address + "updatepassword.php";

    try {
      final response = await http.post(url, body: {
        'email': email.toString(),
        'password': password.toString(),
        'new_password': newpassword.toString()
      });

      if (response.statusCode == 200) {
        var datauser = json.decode(response.body);
        Fluttertoast.showToast(
          backgroundColor: Colors.blue[800],
          gravity: ToastGravity.TOP,
          msg: "$datauser",
        );
      } else {
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Exception Caught $e",
      );
      print("\n---exception catch here-- \n $e");
    }
  }
}

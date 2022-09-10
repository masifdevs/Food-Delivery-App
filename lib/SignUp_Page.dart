import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:practiceapp/Constants.dart';
import 'package:practiceapp/SignIn_Page.dart';

class SignUp_Page extends StatefulWidget {
  SignUp_Page({Key key}) : super(key: key);

  @override
  _SignUp_PageState createState() => _SignUp_PageState();
}

class _SignUp_PageState extends State<SignUp_Page> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  String _currentAddress;
  LatLng _center;
  Position currentLocation;
  var lng;
  var lat;
  Future<Position> locateUser() async {
    return Geolocator().getCurrentPosition();
  }

  getUserLocation() async {
    currentLocation = await locateUser();
    lng = currentLocation.longitude;
    lat = currentLocation.latitude;
    print("lng $lng -- lat$lat");
    _getAddressFromLatLng();
  }

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  bool _toggleConfirmVisibility = true;
  bool _toggleConfirmVisibility2 = true;
  var message;
  TextEditingController firstNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  TextEditingController cnicInputController;
  TextEditingController phInputController;
  clearTextInput() {
    emailInputController.clear();
    pwdInputController.clear();
    firstNameInputController.clear();
    confirmPwdInputController.clear();
    cnicInputController.clear();
    phInputController.clear();
  }

  @override
  initState() {
    firstNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    cnicInputController = new TextEditingController();
    phInputController = new TextEditingController();

    _getAddressFromLatLng();
    getUserLocation();
    super.initState();
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
                  key: _registerFormKey,
                  child: Column(children: <Widget>[
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 20),
                        child: Column(
                          children: <Widget>[
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: <Widget>[
                            //     // DropdownButtonHideUnderline(
                            //     //   child: DropdownButton<String>(
                            //     //     items: [
                            //     //       DropdownMenuItem<String>(
                            //     //         child: Text('Customer'),
                            //     //         value: 'customer',
                            //     //       ),
                            //     //       DropdownMenuItem<String>(
                            //     //         child: Text('Delivery Boy'),
                            //     //         value: 'delivery boy',
                            //     //       ),
                            //     //     ],
                            //     //     isExpanded: false,
                            //     //     onChanged: (String value) {
                            //     //       setState(() {
                            //     //         _value = value;
                            //     //       });
                            //     //     },
                            //     //     value: _value,
                            //     //     iconSize: 30,
                            //     //   ),
                            //     // ),
                            //   ],
                            // ),
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'CNIC number'),
                              controller: cnicInputController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(13),
                              ],
                              validator: cnicValidator,
                            ),
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'User Name'),
                              controller: firstNameInputController,
                              validator: nameValidator,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                              ),
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
                                      _toggleConfirmVisibility2 =
                                          !_toggleConfirmVisibility2;
                                    });
                                  },
                                  icon: _toggleConfirmVisibility2
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                ),
                              ),
                              obscureText: _toggleConfirmVisibility2,
                              controller: pwdInputController,
                              validator: pwdValidator,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
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
                              controller: confirmPwdInputController,
                              obscureText: _toggleConfirmVisibility,
                              validator: pwdValidator,
                            ),

                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Mobile number'),
                              controller: phInputController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(11),
                              ],
                              validator: phoneValidator,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        if (_registerFormKey.currentState.validate()) {
                          if (pwdInputController.text ==
                              confirmPwdInputController.text) {
                            var name = firstNameInputController.text;
                            var email = emailInputController.text;
                            var password = pwdInputController.text;
                            var cnic = cnicInputController.text;
                            var mobilenmbr = phInputController.text;
                            // ---
                            var saltedPassword = salt + password;
                            var bytes = utf8.encode(saltedPassword);
                            var passhash = sha256.convert(bytes);

                            print(
                                "$name $email $passhash $cnic $mobilenmbr,$lng,$lat,$_currentAddress;");
                            userRegistration(name, email, passhash, cnic,
                                mobilenmbr, lng, lat, _currentAddress);
                            clearTextInput();
                          } else {
                            Fluttertoast.showToast(
                              backgroundColor: Colors.blue[800],
                              gravity: ToastGravity.TOP,
                              msg: "Exception caught",
                            );
                          }
                        }
                      },
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.blue[800],
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Center(
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                              color: Color(0xFFBDC2CB),
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                        SizedBox(width: 10.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginPage()));
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        )
                      ],
                    ),
                  ])))),
    ));
  }

  userRegistration(name, email, password, cnic, mobilenmbr, lng, lat,
      _currentAddress) async {
    String url = Api_Address + 'regestartion.php';
    final response = await http.post(url, body: {
      'name': name.toString(),
      'email': email.toString(),
      'password': password.toString(),
      'CNIC': cnic.toString(),
      'mobile': mobilenmbr.toString(),
      'lng': lng.toString(),
      'lat': lat.toString(),
      'Address': _currentAddress.toString(),
      'role': 'customer',
    }).timeout(Duration(seconds: 20));

    if (response.statusCode == 200) {
      message = jsonDecode(response.body);
      print(message);
      Fluttertoast.showToast(
        backgroundColor: Colors.blue[800],
        gravity: ToastGravity.TOP,
        msg: message,
      );
    } else {
      throw Exception('Failed to Create Account');
    }
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          currentLocation.latitude, currentLocation.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress = "${place.subLocality} " +
            "${place.locality} " +
            "${place.administrativeArea}, ${place.country}";
        print(_currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  String nameValidator(String value) {
    Pattern pattern = r'^[A-Za-z]+(?:[ _-][A-Za-z0-9]+)*$';

    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Customer Name format is invalid';
    } else if (value.length < 3) {
      return 'Customer Name is invalid';
    } else {
      return null;
    }
  }

  String cnicValidator(String value) {
    Pattern pattern = r'^[0-9]+(?:[ _-][A-Za-z0-9]+)*$';

    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'CNIC format is invalid';
    } else if (value.length < 13) {
      return 'CNIC is invalid';
    } else {
      return null;
    }
  }

  String phoneValidator(String value) {
    Pattern pattern = r'^[0-9]+(?:[ _-][A-Za-z0-9]+)*$';

    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Mobile Number is invalid';
    } else if (value.length < 11) {
      return 'Please enter a valid Mobile Number.';
    } else {
      return null;
    }
  }
}
// Future<void> _ackAlert(BuildContext context) {
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10.0))),
//         title: Text('Error ...!'),
//         content: const Text('Password are not same !!!'),
//         actions: <Widget>[
//           FlatButton(
//             child: Text('Ok'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

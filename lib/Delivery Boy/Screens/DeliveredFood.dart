import 'package:flutter/material.dart';

class DeliveredPage extends StatefulWidget {
  @override
  _DeliveredPageState createState() => _DeliveredPageState();
}

class _DeliveredPageState extends State<DeliveredPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (ctx, indx) => GestureDetector(
          onTap: () {},
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 4.0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Name ",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        "Items : ",
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "Address Bahauddin ZAkariya university Cs depart multan punjab Pakistan",
                    style: TextStyle(fontSize: 16.0),
                  ),
                 ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

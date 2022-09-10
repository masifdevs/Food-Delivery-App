import 'package:flutter/material.dart';

class Spendings extends StatelessWidget {
  final String name;
  final String amount;
  Spendings({
    Key key,
    @required this.name,
    @required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 4.0,
      child: Container(
        width: 150,
        height: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 8.0),
                    Column(
                      children: <Widget>[
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.green[400],
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          "$amount",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

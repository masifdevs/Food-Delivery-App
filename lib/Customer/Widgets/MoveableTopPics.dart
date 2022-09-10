import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoveableTopPics extends StatefulWidget {
  @override
  _MoveableTopPicsState createState() => _MoveableTopPicsState();
}

class _MoveableTopPicsState extends State<MoveableTopPics> {
  @override
  Widget build(BuildContext context) {
    return Carousel(
      boxFit: BoxFit.cover,
      autoplay: true,
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(milliseconds: 1000),
      dotSize: 7.0,
      dotIncreasedColor: Color(0xFF0F0E21),
      dotColor: Color(0xFF1D1E33),
      dotBgColor: Colors.transparent,
      dotPosition: DotPosition.topCenter,
      dotVerticalPadding: 10.0,
      showIndicator: true,
      indicatorBgPadding: 7.0,
      images: [
        NetworkImage(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSbFhBpbbFinEVpEI1z3lex3s29zcl6UltqtQ&usqp=CAU'),
        NetworkImage(
            'https://www.interest.co.nz/sites/default/files/feature_images/ANZ%20credit%20cards.JPG'),
        NetworkImage(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTOeRRR0B8ewWjFEIop7Si9d9OqDQ5Hc_dRAQ&usqp=CAU'),
      ],
    );
  }
}

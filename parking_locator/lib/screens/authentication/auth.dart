import 'package:flutter/material.dart';
import 'package:parking_locator/screens/authentication/auth2.dart';

import 'package:parking_locator/widgets/drawer.dart';
import 'package:parking_locator/constants.dart';
// const Color mainColor=Color(0xFF5a5aff);

class AuthScreen extends StatelessWidget {
  static const mainColor = Constants.mainColor;
  static const secColor = Constants.secColor;
  static const backgroundColor = Constants.mainColor;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: mainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: size.height * 0.05),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Park Me",
              style: TextStyle(
                  fontFamily: "Alegreya",
                  fontWeight: FontWeight.bold,
                  color: secColor,
                  fontSize: 45),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          // Container(
          //   alignment: Alignment.center,
          //   child: new Image.asset('assets/images/img4.jpg'),
          // ),
          SizedBox(height: size.height * 0.03),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: RaisedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/auth');
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              textColor: Colors.white,
              padding: const EdgeInsets.all(0),
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                width: size.width * 0.5,
                color: secColor,
                padding: const EdgeInsets.all(0),
                child: Text(
                  "Get Started",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

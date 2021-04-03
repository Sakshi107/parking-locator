import 'package:flutter/material.dart';

class LoginOption extends StatelessWidget {
  static const mainColor=Color(0xFFAFEADC);
  static const secColor=Color(0xFF041E42);
  static const backgroundColor=Color(0xFFAFEADC);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Text(
          "Existing user?",
          style: TextStyle(
            fontSize: 16,
          ),
        ),

        SizedBox(
          height: 16,
        ),

        Container(
          height: 40,
          decoration: BoxDecoration(
            color:secColor,
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF041E42).withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child:  Center(
            child: Text(
              "LOGIN",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
          ),
        ),

      ],
    );
  }
}
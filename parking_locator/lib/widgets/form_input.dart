import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String str;
  final Function onChanged;
  final TextInputType type;
  final bool isPassword;
  Input({this.str, this.onChanged, this.type,this.isPassword});
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      onChanged: onChanged,
      textInputAction: TextInputAction.next,
      keyboardType: type,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: str,
        hintStyle: TextStyle(
          fontSize: 16,
          color: Color(0xFF3F3C31),
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        fillColor: Colors.black38,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      ),
    );
  }
}

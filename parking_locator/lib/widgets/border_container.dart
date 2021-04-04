import 'package:flutter/material.dart';

class BorderedContainer extends StatelessWidget {
  final String title;
  final String value;
  const BorderedContainer({
    this.title,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      color:Color(0xFFC7D3D4).withOpacity(0.9),
     
      // margin: margin ??  const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        // width: 100,
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Text(title,maxLines:3,style: TextStyle( fontWeight: FontWeight.bold,fontSize:18.0)),
          SizedBox(height:8.0),
          Text(value,style: TextStyle( fontSize:18.0 ),),
          ],
        ),
      ),
    );
  }
}

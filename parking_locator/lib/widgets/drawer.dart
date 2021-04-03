import 'package:flutter/material.dart';

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: kSubMainColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'PARK APP',
                      style: TextStyle(color: headingColor, fontSize: 28),
                    ),
                    CircleAvatar(
                      maxRadius:35,
                      backgroundColor: kMainColor,
                      child: Text(
                        "MAP",
                        style: TextStyle(color:headingColor,fontSize: 40.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ListTile(
            title: Text('Add Spot'),
            onTap: () => {Navigator.of(context).pushReplacementNamed('/add_spot')},
          ),
           Divider(color: kMainColor),
           ListTile(
            title: Text('Add item '),
            onTap: () => {Navigator.of(context).pushReplacementNamed('/add_item')},
          ),
           Divider(color: kMainColor),
          ListTile(
            title: Text('Orders'),
            onTap: () => {Navigator.of(context).pushReplacementNamed('/my_orders')},
          ),
           Divider(color: kMainColor),
          ListTile(
            title: Text('My Account'),
            onTap: () => {Navigator.of(context).pushReplacementNamed('/my_account')},
          ),
           Divider(color: kMainColor),
          ListTile(
            title: Text('QC Data'),
            onTap: () => {Navigator.of(context).pushReplacementNamed('/oc_data')},
          ),
           Divider(color: kMainColor),
          ListTile(
            title: Text('My Reviews'),
            onTap: () => {Navigator.of(context).pushReplacementNamed('/my_reviews')},
          ),
          Divider(color: kMainColor),
          ListTile(
            title: Text('Contact Services'),
            onTap: () => {Navigator.of(context).pushReplacementNamed('/contact_service')},
          ),
        ],
      ),
    ),
    );
  }
}

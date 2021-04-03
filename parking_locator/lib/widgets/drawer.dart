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
                    'BOOK PARK',
                    style: TextStyle(color: headingColor, fontSize: 28),
                  ),
                  CircleAvatar(
                    maxRadius: 35,
                    backgroundColor: kMainColor,
                    child: Text(
                      "M",
                      style: TextStyle(color: headingColor, fontSize: 40.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () => {Navigator.of(context).pushNamed('/search')},
          ),
          Divider(color: kMainColor),
          ListTile(
            title: Text('Add Spot'),
            onTap: () => {Navigator.of(context).pushNamed('/add_spot')},
          ),
          Divider(color: kMainColor),
          ListTile(
            title: Text('My Parking slots'),
            onTap: () => {Navigator.of(context).pushNamed('/my_spots')},
          ),
          Divider(color: kMainColor),
          ListTile(
            title: Text('My Bookings'),
            onTap: () => {Navigator.of(context).pushNamed('/my_booking')},
          ),
          Divider(color: kMainColor),
        ],
      ),
    ));
  }
}

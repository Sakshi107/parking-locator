import 'package:flutter/material.dart';
import 'package:parking_locator/constants.dart';

// const Constants.secColor = Color(0xFFFF785B);
// const kSubMainColor = Color(0xFFDEE8FF);
// const headingColor = Color(0xFF002140);

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color:Constants.mainColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Column(
                children: [
                  Text(
                    'BOOK PARK',
                    style: TextStyle(color: Constants.secColor, fontSize: 28),
                  ),
                  SizedBox(height:10.0),
                  CircleAvatar(
                    maxRadius: 35,
                    backgroundColor:Constants.secColor,
                    child: Text(
                      "P",
                      style: TextStyle(color: Constants.mainColor, fontSize: 40.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
                    Icons.menu,
                    color: Constants.secColor,
                  ),
            title: Text('Home'),
            onTap: () => {Navigator.of(context).pushNamed('/search')},
          ),
          Divider(color: Constants.secColor),
          ListTile(
            leading: Icon(
                    Icons.add_box,
                    color: Constants.secColor,
                  ),
            title: Text('Add Spot'),
            onTap: () => {Navigator.of(context).pushNamed('/add_spot')},
          ),
          Divider(color: Constants.secColor),
          ListTile(
            leading: Icon(
                    Icons.car_repair,
                    color: Constants.secColor,
                  ),
            title: Text('My Parking slots'),
            onTap: () => {Navigator.of(context).pushNamed('/my_spots')},
          ),
          Divider(color: Constants.secColor),
          ListTile(
            leading: Icon(
                    Icons.book,
                    color: Constants.secColor,
                  ),
            title: Text('My Bookings'),
            onTap: () => {Navigator.of(context).pushNamed('/my_booking')},
          ),
          Divider(color: Constants.secColor),
        ],
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parking_locator/models/place.dart';

// import 'package:parking_locator/screens/authentication/auth.dart';
import 'package:parking_locator/screens/authentication/auth2.dart';
import 'package:parking_locator/screens/addSpot.dart';
import 'package:parking_locator/screens/mySpots.dart';
import 'package:parking_locator/screens/placeDetails.dart';

import 'package:parking_locator/screens/search.dart';

import 'package:parking_locator/services/geolocator_service.dart';
import 'package:parking_locator/services/places_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final locatorService = GeoLocatorService();
  final placesService = PlacesService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          FutureProvider(create: (context) => locatorService.getLocation()),
          FutureProvider(create: (context) {
            ImageConfiguration configuration =
                createLocalImageConfiguration(context, size: Size(100, 100));
            return BitmapDescriptor.fromAssetImage(
                configuration, 'assets/parking-icon.png');
          }),
          ProxyProvider2<Position, BitmapDescriptor, Future<List<Place>>>(
            update: (context, position, icon, places) {
              return (position != null)
                  ? placesService.getPlaces(
                      position.latitude, position.longitude, icon)
                  : null;
            },
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Parking App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // home: Search(),
          // home: SignUpSection(),
          initialRoute: '/',
          routes: {
            '/': (context) => Search(),

            // '/': (context) => AuthScreen(),
            '/auth': (context) => HomePage(),
            '/search': (context) => Search(),
            '/add_spot': (context) => AddSpot(),
            '/my_spots': (context) => MySpots(),
            '/place_details': (context) => PlaceDetails(),
          },
        ));
  }
}

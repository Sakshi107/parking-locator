import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_locator/services/geolocator_service.dart';
import 'package:parking_locator/services/marker_service.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoder/geocoder.dart';
import '../models/place.dart';
import 'package:parking_locator/screens/addForm.dart';

class AddSpot extends StatefulWidget {
  @override
  _AddSpotState createState() => _AddSpotState();
}

class _AddSpotState extends State<AddSpot> {
  List<Marker> myMarker = [];
  LatLng abc;

  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final placesProvider = Provider.of<Future<List<Place>>>(context);
    final geoService = GeoLocatorService();
    final markerService = MarkerService();
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              child: Icon(Icons.arrow_back_ios),
              onTap: () {
                Navigator.of(context).pop();
              }),
          title: Text('Add a Parking Spot'),
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
              target:
                  LatLng(currentPosition.latitude, currentPosition.longitude),
              zoom: 16.0),
          zoomGesturesEnabled: true,
          markers: Set.from(myMarker),
          mapType: MapType.hybrid,
          onTap: _handleTap,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_location_rounded),
          backgroundColor: Colors.green,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddForm(tappedpoint: abc, address: address),
                ));
          },
        ));
  }

  _handleTap(LatLng tappedPoint) {
    print(tappedPoint);
    setState(() {
      abc = tappedPoint;
      print(abc);
      getUserLocation();
      myMarker = [];
      myMarker.add(Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          draggable: true,
          onDragEnd: (dragEndPosition) {
            print(dragEndPosition);
          }));
    });
  }

  double lat, long;
  String address = "No address selected";

  void getUserLocation() async {
    print("yoo");
    print(abc.latitude);
    lat = abc.latitude;
    long = abc.longitude;
    final coordinates = new Coordinates(lat, long);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      address = first.addressLine;
    });
    print(
        ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    // return first.addressLine;
  }
}

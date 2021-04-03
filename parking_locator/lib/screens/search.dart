import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_locator/screens/placeDetails.dart';
import 'package:parking_locator/services/geolocator_service.dart';
import 'package:parking_locator/services/dbservice.dart';
import 'package:parking_locator/screens/confirm_booking.dart';
import 'package:parking_locator/services/marker_service.dart';
import 'package:parking_locator/widgets/drawer.dart';
import 'package:parking_locator/constants.dart';



import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/place.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final placesProvider = Provider.of<Future<List<Place>>>(context);
    final geoService = GeoLocatorService();
    final markerService = MarkerService();

    return FutureProvider(
      create: (context) => placesProvider,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.secColor,
          title: Text("Cark Park"),
        ),
        drawer: NavDrawer(),
        body: (currentPosition != null)
            ? Consumer<List<Place>>(
                builder: (_, places, __) {
                  var markers = (places != null)
                      ? markerService.getMarkers(places)
                      : List<Marker>();
                  return (places != null)
                      ? Column(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height / 2,
                              width: MediaQuery.of(context).size.width,
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(currentPosition.latitude,
                                        currentPosition.longitude),
                                    zoom: 16.0),
                                zoomGesturesEnabled: true,
                                markers: Set<Marker>.of(markers),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Expanded(
                              child: (places.length > 0)
                                  ? ListView.builder(
                                      itemCount: places.length,
                                      itemBuilder: (context, index) {
                                        return FutureProvider(
                                          initialData: Container(),
                                          create: (context) =>
                                              geoService.getDistance(
                                            currentPosition.latitude,
                                            currentPosition.longitude,
                                            places[index].lat,
                                            places[index].long,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PlaceDetails(
                                                      spotId:
                                                          places[index].slotID,
                                                    ),
                                                  ));
                                            },
                                            child: Card(
                                              child: ListTile(
                                                title:
                                                    Text(places[index].address),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 3.0,
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                  ],
                                                ),
                                                trailing: IconButton(
                                                  icon: Icon(Icons.directions),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  onPressed: () {
                                                    _launchMapsUrl(
                                                        places[index].lat,
                                                        places[index].long);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                  : Center(
                                      child: Text('No Parking Found Nearby'),
                                    ),
                            )
                          ],
                        )
                      : Center(child: CircularProgressIndicator());
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  void _launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

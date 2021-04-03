import 'package:parking_locator/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PlacesService {
  final key = 'AIzaSyCLuXe__CHkfuS42u3fc4e5H4Z5F-gjkLM';

  Future<List<Place>> getPlaces(
      double lat, double lng, BitmapDescriptor icon) async {
    var url =
        Uri.parse('http://127.0.0.1:5000/parking/nearme/?lat=$lat&long=$lng&radius=10000');
    print(url);
    String token =
        "bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ3YWxsZXRCYWxhbmNlIjoxMDAsIl9pZCI6IjYwNjZmYTZkYTQxY2JmMmEwOGY2YTY0NiIsIm5hbWUiOiJIaXJhbCIsImVtYWlsIjoiaGlyYWxAZ21haWwuY29tIiwibW9iaWxlIjoiMTIzNDU2Nzg5MCIsInVzZXJJRCI6IjE4NWNhZGQyLWI2Y2YtNGM4MC05MGZjLTc3M2Q5NTg3MGRhYiIsIl9fdiI6MCwiaWF0IjoxNjE3NDM0MDEyfQ.N63VBN08sRBF8YWpehOvGjr_Ay8Ds_sHhU7_PROUej0";
    var response = await http.get(
      url,
      headers: {
        "authorization": token,
        "Content-Type": "application/json",
      },
    );

    // var response = await http.get(Uri.parse(
    //     'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=parking&rankby=distance&key=$key'));
    // print(response.body);
    var json = convert.jsonDecode(response.body);
    // print(json);
    var jsonResults = json['parkings'];
    print("im here");
    print(jsonResults);
    for (int i = 0; i < jsonResults.length; i++) {
      print(i);
      print(jsonResults[i]);
      print(jsonResults[i]['Location']['coordinates'][0]);
      print(jsonResults[i]['activeHours']);
    }
    print(jsonResults.map((place) => Place.fromJson(place,icon)).toList());
    return jsonResults.map<Place>((place) => Place.fromJson(place,icon)).toList();
  }
}

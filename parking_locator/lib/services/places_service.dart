import 'package:parking_locator/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PlacesService {
  final key = 'AIzaSyCLuXe__CHkfuS42u3fc4e5H4Z5F-gjkLM';

  Future<List<Place>> getPlaces(
      double lat, double lng, BitmapDescriptor icon) async {
    var url = Uri.parse(
        'http://127.0.0.1:5000/parking/nearme/?lat=$lat&long=$lng&radius=5000');
    print(url);
    String token =
        "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ3YWxsZXRCYWxhbmNlIjoxMDAsInVzZXJJRCI6IjBjNjgyMTk2LWVmMzMtNGJmZS1hNDlkLTAyYjk4ZmMwYjgzMSIsIl9pZCI6IjYwNjZiMjI1ODhiZjJlMjEyODhhOTU1YyIsIm5hbWUiOiJEZWVwYW5zaHUgVmFuZ2FuaSIsImVtYWlsIjoidmFuZ2FuaWRlZXBhbnNodUBnbWFpbC5jb20iLCJtb2JpbGUiOiI5MTY3Njg3NzEyIiwiX192IjowLCJpYXQiOjE2MTczNDMwMTN9.yoQOPwMZTmJ0YBd-jaAeCtHTG_gb76mnupvg0KYsa3w";
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
    print("im here inside place servuces");
    print(lat);
    print(lng);
    print(jsonResults);
    // for (int i = 0; i < jsonResults.length; i++) {
    //   print(i);
    //   print(jsonResults[i]);
    //   print(jsonResults[i]['Location']['coordinates'][0]);
    //   print(jsonResults[i]['activeHours']);
    // }
    // print(jsonResults.map((place) => Place.fromJson(place,icon)).toList());
    return jsonResults
        .map<Place>((place) => Place.fromJson(place, icon))
        .toList();
  }
}

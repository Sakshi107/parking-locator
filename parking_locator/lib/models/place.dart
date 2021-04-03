import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_locator/models/geometry.dart';

// class Place{
//   final String name;
//   final double rating;
//   final int userRatingCount;
//   final String vicinity;
//   final Geometry geometry;
//   final BitmapDescriptor icon;

//   Place({this.geometry, this.name, this.rating, this.userRatingCount, this.vicinity, this.icon});

//   Place.fromJson(Map<dynamic, dynamic> parsedJson, BitmapDescriptor icon)
//     :name = parsedJson['name'],
//     rating = (parsedJson['rating'] !=null) ? parsedJson['rating'].toDouble() : null,
//     userRatingCount = (parsedJson['user_ratings_total'] != null) ? parsedJson['user_ratings_total'] : null,
//     vicinity = parsedJson['vicinity'],
//     geometry = Geometry.fromJson(parsedJson['geometry']),
//     icon=icon;

// }
// 
class Place {
  final String address;
  final double lat;
  final double long;
  final String slotID;
  final String from;
  final String to;
  final BitmapDescriptor icon;

  Place({
    this.address,
    this.lat,
    this.long,
    this.from,
    this.to,
    this.slotID,
    this.icon
  });

  Place.fromJson(Map<dynamic, dynamic> parsedJson, BitmapDescriptor icon)
      : address = parsedJson['address'],
        lat = parsedJson['Location']['coordinates'][0].toDouble(),
        long = parsedJson['Location']['coordinates'][1].toDouble(),
        from = parsedJson['activeHours']['start'].toString(),
        to= parsedJson['activeHours']['end'].toString(),
            icon=icon,
        slotID = parsedJson['slotID'];
}

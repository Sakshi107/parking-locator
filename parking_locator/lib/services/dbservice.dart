import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert' as convert;
import 'dart:convert';

import 'package:parking_locator/models/place.dart';
import 'package:parking_locator/models/placeDetails.dart';

class DbMethods {
  addSpot(lat, long, startTime, endTime, address, type) async {
    print("imhere");
    print("end" + endTime);
    print("type" + type);
    String token =
        "bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ3YWxsZXRCYWxhbmNlIjoxMDAsIl9pZCI6IjYwNjZmYTZkYTQxY2JmMmEwOGY2YTY0NiIsIm5hbWUiOiJIaXJhbCIsImVtYWlsIjoiaGlyYWxAZ21haWwuY29tIiwibW9iaWxlIjoiMTIzNDU2Nzg5MCIsInVzZXJJRCI6IjE4NWNhZGQyLWI2Y2YtNGM4MC05MGZjLTc3M2Q5NTg3MGRhYiIsIl9fdiI6MCwiaWF0IjoxNjE3NDUzNjE5fQ.czhfN16oe57qpS8wt_CNt3giA2f5FFOvKjhD46IPnbU";
    // try {
    var url = Uri.parse('http://127.0.0.1:5000/user/myParking');
    print(url);
    var res = await http.post(
      url,
      body: json.encode({
        "lat": lat,
        "long": long,
        "startTime": startTime,
        "endTime": endTime,
        "address": address,
        "parkingType": type,
        "chargesPerHour": 100
      }),
      headers: {
        "authorization": token,
        "Content-Type": "application/json",
      },
    );

    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      print("Spot added");
    } else {
      throw Exception('Failed to create album.');
    }
  }

  //get details of a parkspot
  Future getPlaceDetails(String spotId) async {
    var url =Uri.parse('http://127.0.0.1:5000/parking/$spotId');
    print(url);
    String token ="bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ3YWxsZXRCYWxhbmNlIjoxMDAsIl9pZCI6IjYwNjZmYTZkYTQxY2JmMmEwOGY2YTY0NiIsIm5hbWUiOiJIaXJhbCIsImVtYWlsIjoiaGlyYWxAZ21haWwuY29tIiwibW9iaWxlIjoiMTIzNDU2Nzg5MCIsInVzZXJJRCI6IjE4NWNhZGQyLWI2Y2YtNGM4MC05MGZjLTc3M2Q5NTg3MGRhYiIsIl9fdiI6MCwiaWF0IjoxNjE3NDUzNjE5fQ.czhfN16oe57qpS8wt_CNt3giA2f5FFOvKjhD46IPnbU";
    var response = await http.get(
      url,
      headers: {
        "authorization": token,
        "Content-Type": "application/json",
      },
    );
    var jsonResults = convert.jsonDecode(response.body);
    print(jsonResults['parking']);
    return jsonResults['parking'];
  }
}

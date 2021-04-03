import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert' as convert;

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
      body: convert.json.encode({
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

  mySpots() async {
    String token =
        "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ3YWxsZXRCYWxhbmNlIjoxMDAsInVzZXJJRCI6IjBjNjgyMTk2LWVmMzMtNGJmZS1hNDlkLTAyYjk4ZmMwYjgzMSIsIl9pZCI6IjYwNjZiMjI1ODhiZjJlMjEyODhhOTU1YyIsIm5hbWUiOiJEZWVwYW5zaHUgVmFuZ2FuaSIsImVtYWlsIjoidmFuZ2FuaWRlZXBhbnNodUBnbWFpbC5jb20iLCJtb2JpbGUiOiI5MTY3Njg3NzEyIiwiX192IjowLCJpYXQiOjE2MTczNDMwMTN9.yoQOPwMZTmJ0YBd-jaAeCtHTG_gb76mnupvg0KYsa3w";
    // try {
    var url = Uri.parse('http://127.0.0.1:5000/user/myParking');
    print(url);
    var res = await http.get(
      url,
      headers: {
        "authorization": token,
        "Content-Type": "application/json",
      },
    );

    var json = convert.jsonDecode(res.body);
    print("hi");
    print(json);

    var jsonResults = json['parkings'];
    print(jsonResults);
    return jsonResults;
    // var jsonResults = json
  }

  spotDetail(String spotID) async {
    String token =
        "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ3YWxsZXRCYWxhbmNlIjoxMDAsInVzZXJJRCI6IjBjNjgyMTk2LWVmMzMtNGJmZS1hNDlkLTAyYjk4ZmMwYjgzMSIsIl9pZCI6IjYwNjZiMjI1ODhiZjJlMjEyODhhOTU1YyIsIm5hbWUiOiJEZWVwYW5zaHUgVmFuZ2FuaSIsImVtYWlsIjoidmFuZ2FuaWRlZXBhbnNodUBnbWFpbC5jb20iLCJtb2JpbGUiOiI5MTY3Njg3NzEyIiwiX192IjowLCJpYXQiOjE2MTczNDMwMTN9.yoQOPwMZTmJ0YBd-jaAeCtHTG_gb76mnupvg0KYsa3w";
    // try {
    var url = Uri.parse(
        'http://127.0.0.1:5000/user/myParking/bookings/?spotID=$spotID');
    print(url);
    var res = await http.get(
      url,
      headers: {
        "authorization": token,
        "Content-Type": "application/json",
      },
    );
    var json = convert.jsonDecode(res.body);
    print("hi");
    print(json);

    var jsonResults = json['bookings'];
    print(jsonResults);
    return jsonResults;
  }

  bookingDetails(String spotID, startTime, endTime) async {
    String token =
        "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ3YWxsZXRCYWxhbmNlIjoxMDAsInVzZXJJRCI6IjBjNjgyMTk2LWVmMzMtNGJmZS1hNDlkLTAyYjk4ZmMwYjgzMSIsIl9pZCI6IjYwNjZiMjI1ODhiZjJlMjEyODhhOTU1YyIsIm5hbWUiOiJEZWVwYW5zaHUgVmFuZ2FuaSIsImVtYWlsIjoidmFuZ2FuaWRlZXBhbnNodUBnbWFpbC5jb20iLCJtb2JpbGUiOiI5MTY3Njg3NzEyIiwiX192IjowLCJpYXQiOjE2MTczNDMwMTN9.yoQOPwMZTmJ0YBd-jaAeCtHTG_gb76mnupvg0KYsa3w";
    // try {
    var url = Uri.parse(
        'http://127.0.0.1:5000/user/myParking/$spotID/setActiveHours');
    print(url);
    var res = await http.post(
      url,
      body: convert.json.encode({
        "startTime": startTime,
        "endTime": endTime,
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
      throw Exception('Failed to create album.2');
    }
  }
}

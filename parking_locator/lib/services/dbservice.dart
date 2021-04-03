import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class DbMethods {
  addSpot(lat, long, startTime, endTime, address, type) async {
    print("imhere");
    // try {
    var url = Uri.parse('http://127.0.0.1:5000/user/myParking');
    print(url);
    var res = await http.post(
      url,
      body: json.encode({
        "lat": lat,
        "long": long,
        "startTime": startTime,
        "endTime ": endTime,
        'address': address,
        'parkingtype': type,
        'chargesPerHour': 100
      }),
      headers: {
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
}

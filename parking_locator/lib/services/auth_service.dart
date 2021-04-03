import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class AuthMethods {
  signup(name,email,phone, password) async {
    print("imhere");
   // try {
    var url = Uri.parse('http://127.0.0.1:5000/auth/signup');
    print(url);
    //  var request = await httpClient.post('192.168.0.108', 3000, "/auth/signup");
//  var res = await request.close();
    var res = await http.post(
      url,
      body: json.encode({
        "name": name,
        "email": email,
        "mobile": phone,
        "password": password
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );

    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      print("signed up");
    } else {
      throw Exception('Failed to create album.');
    }
  }
    signin(email, password) async {
    print("imhere");
   // try {
    var url = Uri.parse('http://127.0.0.1:5000/auth/login');
    print(url);
    //  var request = await httpClient.post('192.168.0.108', 3000, "/auth/signup");
//  var res = await request.close();
    var res = await http.post(
      url,
      body: json.encode({
        "email": email,
        "password": password
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );

    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      print("signed in");
    } else {
      throw Exception('Failed to create album.');
    }
  }
}

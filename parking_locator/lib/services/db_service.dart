import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class DbMethods {
  signup(name, email, phone, password) async {
    print("imhere");
    // try {
    var url = Uri.parse('http://127.0.0.1:5000/auth/signup');
    print(url);
    //  var request = await httpClient.post('192.168.0.108', 3000, "/auth/signup");
//  var res = await request.close();
    String token =
        "bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ3YWxsZXRCYWxhbmNlIjoxMDAsIl9pZCI6IjYwNjg2NjVjNDAxMjA5NGFiOGE1OWNiMiIsIm5hbWUiOiJQYXJ0aCIsImVtYWlsIjoicGFydGhAZ21haWwuY29tIiwibW9iaWxlIjoiOTk5OTk5OTk5IiwidXNlcklEIjoiZTM3ZTU5ZGUtY2Q5OC00YTM5LTkxMjQtNjE5NDFiMTQyYzNjIiwiX192IjowLCJpYXQiOjE2MTc0NTQ2ODR9.GG5kXrjKCUh0670muir1b4oIQBfRWsgLoM7-3woR1Ww";
    var response = await http.get(
      url,
      headers: {
        "authorization": token,
        "Content-Type": "application/json",
      },
    );
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
}

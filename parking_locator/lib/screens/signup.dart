import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class SignUpSection extends StatelessWidget {
  var email;
  var password;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
        ),
        child: SafeArea(
            child: ListView(padding: const EdgeInsets.all(16), children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CupertinoTextField(
                  placeholder: "Email",
                  onChanged: (value) {
                    email = value;
                  })),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CupertinoTextField(
                  placeholder: "Password",
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  })),
          FlatButton.icon(
              onPressed: () {
                print(email);
                print(password);
                signup(email, password);
              },
              icon: Icon(Icons.save),
              label: Text("Sign UP"))
        ])));
  }
}

signup(email, password) async {
  print("imhere");
  var httpClient = HttpClient();
  // try {
  var url = Uri.parse('http://127.0.0.1:5000/auth/signup');
  print(url);
  //  var request = await httpClient.post('192.168.0.108', 3000, "/auth/signup");
//  var res = await request.close();
  var res = await http.post(
    url,
    body: json.encode({
      "name": "Hiral3",
      "email": email,
      "mobile": "1234567890",
      "password": password
    }),
    headers: {
      "Content-Type":"application/json",
    },
  );
  // final response = json.decode(res);
  print("hellooooo");
  print(res);
  print(res.statusCode);
  print(res.body);
  if (res.statusCode == 200) {
    print("sign up");
  } else {
    throw Exception('Failed to create album.');
  }
  // } catch (e) {
  // print(e);
  // }

  // var url = Uri.parse('http://192.168.0.108:5000/auth/signup');
  // final http.Response response = await http.post(
  //   url,
  //   headers: <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //   },
  //   body: jsonEncode(<String, String>{
  //     'email': email,
  //     'password': password,
  //     "name": "Sakshi",
  //     "mobile": "1234456789"
  //   }),
  // );

  // if (response.statusCode == 201) {
  //   print(response);
  // } else {
  //   throw Exception('Failed to create album.');
  // }
}

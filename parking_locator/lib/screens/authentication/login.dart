import 'package:flutter/material.dart';
import 'package:parking_locator/services/auth_service.dart';
import 'package:parking_locator/constants.dart';


// import 'package:firebase_auth/firebase_auth.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static const mainColor = Constants.mainColor;
  static const secColor = Constants.secColor;
  static const backgroundColor = Constants.mainColor;

  final TextEditingController _controller = TextEditingController();
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              FlatButton(
                child: Text("Close Dialog"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
  AuthMethods _authMethods = AuthMethods();

  Future<String> _loginAccount() async {
    // Call the user's CollectionReference to add a new user
    await _authMethods
        .signin(
             _loginEmail,  _loginPassword)
        .then((value) => Navigator.pushReplacementNamed(context, '/search'))
        .catchError((error) => print("Failed to add user: $error"));
    return "xyz";
  }

  void _submitForm() async {
    setState(() {
      _loginFormLoading = true;
    });

    String _loginFeedback = await _loginAccount();

    if (_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);

      setState(() {
        print("hi");
        _loginFormLoading = false;
      });
    } else {
     Navigator.pop(context);
    }
  }

  bool _loginFormLoading = false;
  String _loginEmail = "";
  String _loginPassword = "";

  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Welcome to",
          style: TextStyle(
            fontSize: 16,
            color: secColor,
            height: 2,
          ),
        ),
        Text(
          "ParkMe",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: secColor,
            letterSpacing: 2,
            height: 1,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          "Please login to continue",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF1C1C1C),
            height: 1,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          onChanged: (value) {
            _loginEmail = value;
          },
          onSubmitted: (value) {
            _passwordFocusNode.requestFocus();
          },
          textInputAction: TextInputAction.next,
          // controller: _controller,
          decoration: InputDecoration(
            hintText: 'Email / Username',
            hintStyle: TextStyle(
              fontSize: 16,
              color: secColor,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.black12,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          obscureText: true,
          onChanged: (value) {
            _loginPassword = value;
          },
          focusNode: _passwordFocusNode,
          //isPasswordField: true,
          onSubmitted: (value) {
            _submitForm();
          },
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(
              fontSize: 16,
              color: secColor,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.black12,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        InkWell(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: secColor,
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF041E42).withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 4,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "LOGIN",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
              ),
            ),
          ),
          onTap: () {
            _submitForm();
            //HomePage();
          },
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}

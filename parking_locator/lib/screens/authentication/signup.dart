import 'package:flutter/material.dart';
import 'package:parking_locator/services/auth_service.dart';
import 'package:parking_locator/widgets/form_input.dart';




class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  static const mainColor = Color(0xFFAFEADC);
  static const secColor = Color(0xFF041E42);
  static const backgroundColor = Color(0xFFAFEADC);
  AuthMethods _authMethods = AuthMethods();

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

  Future<String> createUser() async {
 

    // Call the user's CollectionReference to add a new user
    await _authMethods.signup(_registerName,_registerEmail,_registerPhone,_registerPassword)
        .then((value) => Navigator.pushReplacementNamed(context, '/search'))
        .catchError((error) => print("Failed to add user: $error"));
    return "xyz";
  }

  void _submitForm() async {
    setState(() {
      _registerFormLoading = true;
    });

    String _createAccountFeedback = await createUser();

    if (_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);

      setState(() {
        _registerFormLoading = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  bool _registerFormLoading = false;
  String _registerEmail = "";
  String _registerName = "";
  String _registerPassword = "";
  String _registerPhone = "";



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Sign up with",
          style: TextStyle(
            fontSize: 16,
            color: mainColor,
            height: 2,
          ),
        ),
        Text(
          "CarPark",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: mainColor,
            letterSpacing: 2,
            height: 1,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Input(str:"Name",
         onChanged: (value) {
            _registerName = value;
          },
          type:TextInputType.text,
          isPassword: false,
        ),
        SizedBox(
          height: 16,
        ),
      Input(str:"Email",
         onChanged: (value) {
            _registerEmail = value;
          },
          type:TextInputType.text,
          isPassword: false,
        ),
        SizedBox(
          height: 16,
        ),
        Input(str:"Phone",
         onChanged: (value) {
            _registerPhone = value;
          },
          type:TextInputType.phone,
          isPassword: false,
        ),
        Input(str:"Password",
         onChanged: (value) {
            _registerPassword = value;
          },
          type:TextInputType.visiblePassword,
          isPassword: true,
       ),
        InkWell(
          child: Container(
            
            height: 40,
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: mainColor,
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "SIGN UP",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: secColor,
                ),
              ),
            ),
          ),
          onTap: () {
            _submitForm();
          },
          //isLoading: _registerFormLoading,
        ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }
}

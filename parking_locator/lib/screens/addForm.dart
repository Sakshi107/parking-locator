import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:geocoder/geocoder.dart';
import 'package:parking_locator/screens/addSpot.dart';
import 'package:parking_locator/services/dbservice.dart';

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);

class AddForm extends StatefulWidget {
  final LatLng tappedpoint;
  final String address;
  AddForm({this.tappedpoint, this.address});

  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // TextEditingController _nameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeControllerFrom = TextEditingController();
  TextEditingController _timeControllerTo = TextEditingController();
  DbMethods _addSpot = DbMethods();

  // String _locationName;
  double _height;
  double _width;
  String _setFromTime, _setToTime, _setDate;

  String _hour, _minute, _time;

  String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedFromTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedToTime = TimeOfDay(hour: 00, minute: 00);
  // String address;
  double lat, long;
  int cost;
  TimeOfDay startTime, endTime;
  String _selectedType, parkingtype, address;
  List<String> _typeList = ['Open', 'Covered'];

  // void loadTypeList() {
  //   typeList = [];
  //   typeList.add(new DropdownMenuItem(
  //     child: new Text('Open'),
  //     value: 0,
  //   ));
  //   typeList.add(new DropdownMenuItem(
  //     child: new Text('Covered'),
  //     value: 1,
  //   ));
  // }

  // List<Widget> getFormWidget() {
  //   List<Widget> formWidget = new List();

  //   formWidget.add(new DropdownButton(
  //     hint: new Text('Select Parking Type'),
  //     items: typeList,
  //     value: selectedType,
  //     onChanged: (value) {
  //       setState(() {
  //         selectedType = value;
  //       });
  //     },
  //     isExpanded: true,
  //   ));

  //   return formWidget;
  // }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context, int a) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedFromTime,
    );
    if (picked != null)
      setState(() {
        if (a == 0) {
          selectedFromTime = picked;
          _timeControllerFrom.text = formatDate(
              DateTime(
                  2019, 08, 1, selectedFromTime.hour, selectedFromTime.minute),
              [hh, ':', nn, " ", am]).toString();
        } else {
          selectedToTime = picked;
          _timeControllerTo.text = formatDate(
              DateTime(2019, 08, 1, selectedToTime.hour, selectedToTime.minute),
              [hh, ':', nn, " ", am]).toString();
        }
        // _hour = selectedFromTime.hour.toString();
        // _minute = selectedFromTime.minute.toString();
        // _time = _hour + ' : ' + _minute;
        // _timeController.text = _time;
      });
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat('HH:mm:ss');
    // print(format.format(dt));
    return format.format(dt);
  }

  bool validateForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    }
    return false;
  }

  void clearForm() {
    _formKey.currentState.reset();
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeControllerFrom.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    _timeControllerTo.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Message"),
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

  Future<dynamic> add() async {
    print(startTime);
    print(endTime);
    var start = formatTimeOfDay(startTime).toString();
    var end = formatTimeOfDay(endTime).toString();
    print("end" + end);
//         toTime: formatTimeOfDay(selectedToTime).toString(),
    return await _addSpot.addSpot(
            _lat, _long, start, end, address, parkingtype, cost)
        // .then((obj) => return "Added parking spot";
        // .catchError((error) => return "Failed to add the parking spot: $error";
        ;
  }

  void _submit() async {
    setState(() {
      _formLoading = true;
    });

    lat = widget.tappedpoint.latitude;
    long = widget.tappedpoint.longitude;
    startTime = selectedFromTime;
    endTime = selectedToTime;
    address = widget.address;
    if (_selectedType == 'Open') {
      parkingtype = "OPEN";
    } else {
      parkingtype = "COVERED";
    }
    print(lat);
    print(long);
    print(startTime);
    print(endTime);
    print(parkingtype);
    print(address);
    print(cost);
    // var obj = await add();
    // print("imhereee");
    // print(obj);
    // if (obj["status"] == "SUCCESS") {
    //   _alertDialogBuilder("Your parking spot has been added");

    //   setState(() {
    //     _formLoading = false;
    //   });
    //   //Navigator.pop(context);
    // } else {
    //   _alertDialogBuilder("Unable to add your parking spot");
    //   Navigator.pop(context);
    // }
  }

  double _lat = 0;
  double _long = 0;
  TimeOfDay _startTime;
  TimeOfDay _endTime;
  String _address = "";
  String _type = "";
  bool _formLoading = false;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              child: Icon(Icons.arrow_back_ios),
              onTap: () {
                Navigator.of(context).pop();
              }),
          title: Text('Additional details'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(widget.address),
              DropdownButton(
                hint: Text('Please choose a Parking Type'),
                value: _selectedType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue;
                  });
                },
                items: _typeList.map((type) {
                  return DropdownMenuItem(
                    child: new Text(type),
                    value: type,
                  );
                }).toList(),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  _selectDate(context);
                  // getUserLocation();
                },
                child: Container(
                  width: _width / 2.4,
                  height: _height / 10,
                  margin: EdgeInsets.only(top: 30),
                  alignment: Alignment.center,
                  // decoration: BoxDecoration(color: Colors.grey[200]),
                  child: TextFormField(
                      // style: TextStyle(fontSize: 40),
                      textAlign: TextAlign.center,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _dateController,
                      onSaved: (String val) {
                        _setDate = val;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: kMainColor,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: kMainColor, width: 1.0),
                        ),
                        border: OutlineInputBorder(
                          // borderRadius: new BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: kMainColor),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          // borderRadius: new BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: kMainColor),
                        ),
                        labelStyle:
                            new TextStyle(color: headingColor, fontSize: 15),
                        labelText: "On date",
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      _selectTime(context, 0);
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      width: _width / 2.4,
                      height: _height / 10,
                      alignment: Alignment.center,
                      child: TextFormField(
                          // style: TextStyle(fontSize: 40),
                          textAlign: TextAlign.center,
                          onSaved: (String val) {
                            _setFromTime = val;
                          },
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _timeControllerFrom,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            prefixIcon: Icon(
                              Icons.alarm,
                              color: kMainColor,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: kMainColor, width: 1.0),
                            ),
                            border: OutlineInputBorder(
                              // borderRadius: new BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: kMainColor),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              // borderRadius: new BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: kMainColor),
                            ),
                            labelStyle: new TextStyle(
                                color: headingColor, fontSize: 15),
                            labelText: "From time",
                          )),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _selectTime(context, 1);
                    },
                    child: Container(
                      width: _width / 2.4,
                      height: _height / 10,
                      alignment: Alignment.center,
                      child: TextFormField(
                          textAlign: TextAlign.center,
                          onSaved: (String val) {
                            _setToTime = val;
                          },
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _timeControllerTo,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            prefixIcon: Icon(
                              Icons.alarm,
                              color: kMainColor,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: kMainColor, width: 1.0),
                            ),
                            border: OutlineInputBorder(
                              // borderRadius: new BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: kMainColor),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              // borderRadius: new BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: kMainColor),
                            ),
                            labelStyle: new TextStyle(
                                color: headingColor, fontSize: 15),
                            labelText: "To time",
                          )),
                    ),
                  ),
                ],
              ),
              CustomFormField(
                  labelText: "Charge per hour " + '\u{20B9}',
                  validatorStr: "the text",
                  prefixicon: Icons.attach_money_outlined,
                  onChanged: (val) => cost = int.parse(val)),
              Center(
                  child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                    primary: kMainColor),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')));
                    _submit();
                  }
                },
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 16.9, color: Colors.white),
                ),
                // textColor: Colors.white70,
              ))
            ],
          ),
        ));
  }
}

class CustomFormField extends StatelessWidget {
  final Function onChanged;
  final String labelText;
  final String validatorStr;
  final IconData prefixicon;

  CustomFormField({
    @required this.onChanged,
    @required this.labelText,
    @required this.validatorStr,
    @required this.prefixicon,
  })  : assert(labelText != null),
        // assert(onChanged != null),
        assert(validatorStr != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextFormField(
        validator: (value) {
          if (value.length == 0) {
            return (validatorStr);
          }
          return null;
        },
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixicon,
            color: kMainColor,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: kMainColor, width: 1.0),
          ),
          border: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.white38),
          ),
          focusedBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(20.0),
            borderSide: BorderSide(color: kMainColor),
          ),
          labelStyle: new TextStyle(color: headingColor, fontSize: 15),
          labelText: labelText,
        ),
      ),
    );
  }
}

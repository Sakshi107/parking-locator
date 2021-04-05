import 'package:flutter/material.dart';
import 'package:parking_locator/services/dbservice.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:parking_locator/constants.dart';



const headingColor = Color(0xFF002140);

class SlotDetails extends StatefulWidget {
  final String spotID;
  SlotDetails({this.spotID});
  @override
  _SlotDetailsState createState() => _SlotDetailsState();
}

class _SlotDetailsState extends State<SlotDetails> {
  final db_methods = DbMethods();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _timeControllerFrom = TextEditingController();
  TextEditingController _timeControllerTo = TextEditingController();
  List<dynamic> spotbooking;
  double _height;
  double _width;
  String _setFromTime, _setToTime;
  String _hour, _minute, _time;
  TimeOfDay startTime, endTime;
  bool _formLoading = false;
  TimeOfDay selectedFromTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedToTime = TimeOfDay(hour: 00, minute: 00);

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
      });
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat('HH:mm:ss');
    // print(format.format(dt));
    return format.format(dt);
  }

  @override
  void initState() {
    getbookings();
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

  Future<String> add() async {
    print(startTime);
    print(endTime);
    var start = formatTimeOfDay(startTime).toString();
    var end = formatTimeOfDay(endTime).toString();
    print("end" + end);
//         toTime: formatTimeOfDay(selectedToTime).toString(),
    await db_methods
        .bookingDetails(widget.spotID, start, end)
        .then((obj) => print("Changed the timings of the parking spot"))
        .catchError((error) =>
            print("Failed to change the timings of the parking spot: $error"));
    return "Successfully updated";
  }

  void _submit() async {
    setState(() {
      _formLoading = true;
    });

    startTime = selectedFromTime;
    endTime = selectedToTime;
    print(startTime);
    print(endTime);
    String _addSpotFeedback = await add();
    if (_addSpotFeedback != null) {
      _alertDialogBuilder(_addSpotFeedback);

      setState(() {
        _formLoading = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void getbookings() async {
    List<dynamic> result;
    result = await db_methods.spotDetail(widget.spotID);
    setState(() {
      spotbooking = result;
    });
    print("hi");
    print(spotbooking);
  }

  // @override
  // void initState() {
  //   getbookings();
  //   // db_methods.spotDetail(widget.spotID);
  // }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
     appBar: AppBar(
          backgroundColor: Constants.secColor,
          title: Text('Slot details'),
        ),
      body: Column(
        children: [
          Form(
              key: _formKey,
              child: Column(
                children: [
                  Text("Edits the spot's timings:"),
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
                                  color:Constants.secColor,
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color:Constants.secColor, width: 1.0),
                                ),
                                border: OutlineInputBorder(
                                  // borderRadius: new BorderRadius.circular(20.0),
                                  borderSide: BorderSide(color:Constants.secColor),
                                ),
                                focusedBorder: new OutlineInputBorder(
                                  // borderRadius: new BorderRadius.circular(20.0),
                                  borderSide: BorderSide(color:Constants.secColor),
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
                                  color:Constants.secColor,
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color:Constants.secColor, width: 1.0),
                                ),
                                border: OutlineInputBorder(
                                  // borderRadius: new BorderRadius.circular(20.0),
                                  borderSide: BorderSide(color:Constants.secColor),
                                ),
                                focusedBorder: new OutlineInputBorder(
                                  // borderRadius: new BorderRadius.circular(20.0),
                                  borderSide: BorderSide(color:Constants.secColor),
                                ),
                                labelStyle: new TextStyle(
                                    color: headingColor, fontSize: 15),
                                labelText: "To time",
                              )),
                        ),
                      ),
                    ],
                  ),
                  Center(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                        //primary:Constants.secColor
                      ),
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
              )),
          SizedBox(height:5.0),
          Text("Slot's booking details"),
          SizedBox(height:10.0),
          Expanded(
              child: (spotbooking != null)
                  ? ListView.builder(
                      itemCount: spotbooking.length,
                      itemBuilder: (context, index) {
                        return Container(
                          //color:Constants.mainColor,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Constants.secColor.withOpacity(0.7),
                            elevation: 7,
                            child: InkWell(
                                borderRadius: BorderRadius.circular(15.0),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SlotDetails(
                                          spotID: spotbooking[index]['slotID']),
                                    ),
                                  );
                                },
                                child: Container(
                                  child: Column(
                                    children: [
                                      // Column(
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   children: [
                                      //     Text(spots[index]['address']),
                                      //     Text("Start time: " +
                                      //         spots[index]['activeHours']['start']),
                                      //     Text("End time: " +
                                      //         spots[index]['activeHours']['end']),
                                      //     Row(
                                      //       children: [
                                      //         Text("Parking Type: " +
                                      //             spots[index]['parkingType']),
                                      //         SizedBox(
                                      //           width: width * 2 / 5,
                                      //         ),
                                      //         Text("Charges: " +
                                      //             (spots[index]['chargesPerHour'])
                                      //                 .toString()),
                                      //       ],
                                      //     ),
                                      //   ],
                                      // )
                                      ListTile(
                                        isThreeLine: true,
                                        title: Text(
                                            spotbooking[index]['user']['name'],style: TextStyle(color:Colors.white),),
                                        subtitle: Text("User email id: " +
                                            spotbooking[index]['user']
                                                ['email'],style: TextStyle(color:Colors.white),),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        );
                      })
                  : Center(
                      child: Text('No Slot Bookings Found'),
                    )),
        ],
      ),
    );
  }
}
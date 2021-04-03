import 'package:flutter/material.dart';
import 'package:parking_locator/services/dbservice.dart';
import 'package:parking_locator/widgets/border_container.dart';
import 'package:parking_locator/widgets/drawer.dart';
import 'package:parking_locator/screens/confirm_booking.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

class PlaceDetails extends StatefulWidget {
  final String spotId;
  PlaceDetails({this.spotId});
  @override
  _PlaceDetailsState createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  DbMethods obj = DbMethods();
  DbBookingMethods _dbmethod = DbBookingMethods();
  String duration, startTime;
  var place;

  void _submit(slotID, lat, long, canBook) async {
    var obj = await _dbmethod.onSubmit(slotID, lat, long, canBook);
    print(obj);
    if (obj["STATUS"] == "SUCCESS") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConfirmBooking(
                  slotID: slotID,
                  carImage: obj["carImage"],
                  bookingId: obj["bookingID"],
                )),
      );
    }
  }

  void _submitAdvance(slotID) async {
    startTime = formatTimeOfDay(selectedFromTime).toString();
    var obj = await _dbmethod.PriorBook(slotID, startTime, duration);
    print(obj);
    if (obj["STATUS"] == "SUCCESS") {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ConfirmBooking(
      //               slotID: slotID,
      //               carImage: obj["carImage"],
      //               bookingId: obj["bookingID"],
      //             )));
    }
  }

  void getDetails() async {
    var resPlace;
    resPlace = await obj.getPlaceDetails(widget.spotId);
    print(resPlace);
    setState(() {
      place = resPlace;
      print(place);
    });
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  String _setFromTime;
  @override
  Widget build(BuildContext context) {
     double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Cark Park"),
      ),
      drawer: NavDrawer(),
      body: place != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BorderedContainer(
                          title: "Address:", value: place["address"]),
                      BorderedContainer(
                          title: "Start Time:",
                          value: place["activeHours"]["start"]),
                      BorderedContainer(
                          title: "End Time:",
                          value: place["activeHours"]["end"]),
                      BorderedContainer(
                          title: "Charges Per Hour :",
                          value: place["chargesPerHour"].toString()),
                      BorderedContainer(
                          title: "Parking Type :",
                          value: place["parkingType"].toString()),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:[ 
                          ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                            //primary: kMainColor
                          ),
                          onPressed: () {
                            print(place['Location']);
                            _submit(
                                place['slotID'],
                                place['Location']['coordinates'][0],
                                place['Location']['coordinates'][1],
                                "false");
                            print("go to confirm booking");
                          },
                          onLongPress: () {
                            print(place['Location']);
                            _submit(
                                place['slotID'],
                                place['Location']['coordinates'][0],
                                place['Location']['coordinates'][1],
                                "true");
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Book Now',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      SizedBox(width:10),
                     ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                            //primary: kMainColor
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ), //RoundedRectangleBorder
                                      title: Text(" Add Advance Booking",
                                          textAlign: TextAlign.center),
                                      content: Column(
                                        // color:Colors.black,
                                        //mainAxisSize:MainAxisSize.min,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              _selectTime(context);
                                            },
                                            child: Container(
                                              // padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                width: 30,
                                                height: 30,
                                              alignment: Alignment.center,
                                              child: TextFormField(
                                                  // style: TextStyle(fontSize: 40),
                                                  textAlign: TextAlign.center,
                                                  onSaved: (String val) {
                                                    _setFromTime = val;
                                                  },
                                                  enabled: false,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  controller:
                                                      _timeControllerFrom,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(5),
                                                    prefixIcon: Icon(
                                                      Icons.alarm,
                                                      color: kMainColor,
                                                    ),
                                                    enabledBorder:
                                                        const OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color: kMainColor,
                                                              width: 1.0),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      // borderRadius: new BorderRadius.circular(20.0),
                                                      borderSide: BorderSide(
                                                          color: kMainColor),
                                                    ),
                                                    focusedBorder:
                                                        new OutlineInputBorder(
                                                      // borderRadius: new BorderRadius.circular(20.0),
                                                      borderSide: BorderSide(
                                                          color: kMainColor),
                                                    ),
                                                    labelStyle: new TextStyle(
                                                        color: headingColor,
                                                        fontSize: 15),
                                                    labelText: "From time",
                                                  )),
                                            ),
                                          ),
                                          TextField(
                                              autofocus: true,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Padding(
                                              padding: EdgeInsets.only(
                                            top: 10.0,
                                          )),

                                          Text("Duration",
                                              textAlign: TextAlign.left),
                                          TextField(
                                              onChanged: (val) {
                                                duration = val;
                                              },
                                              autofocus: true,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Padding(
                                              padding: EdgeInsets.only(
                                            top: 10.0,
                                          )),

                                          RaisedButton(
                                            color: Color(0xff603F83),
                                            onPressed: () {
                                              _submitAdvance(place['slotID']);
                                              Navigator.of(context).pop();
                                            }, //database
                                            child: Text("ADD",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ), //raisedbutton
                                          SizedBox(width: 5.0, height: 10.0),
                                          RaisedButton(
                                            color: Color(0xff603F83),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }, //database
                                            child: Text("CANCEL",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ), //raisedbutton
                                        ], //widget
                                      ), //column
                                    ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Book Advance',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  TimeOfDay selectedFromTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController _timeControllerFrom = TextEditingController();
  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat('HH:mm:ss');
    // print(format.format(dt));
    return format.format(dt);
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedFromTime,
    );
    if (picked != null)
      setState(() {
        selectedFromTime = picked;
        _timeControllerFrom.text = formatDate(
            DateTime(
                2019, 08, 1, selectedFromTime.hour, selectedFromTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  void showalertdialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // actionsOverflowDirection:Vert ,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ), //RoundedRectangleBorder
        title: Text(" Add Advance Booking", textAlign: TextAlign.center),
        content: 
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            // color:Colors.black,
            //mainAxisSize:MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: () {
                  _selectTime(context);
                },
                child: Container(
                  // padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  width: 20,
                  height: 40,
                  alignment: Alignment.center,
                  child: TextFormField(
                      // style: TextStyle(fontSize: 40),
                      textAlign: TextAlign.center,
                      // onSaved: (String val) {
                      //   _setFromTime = val;
                      // },
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
                        labelText: "From time",
                      )),
                ),
              ),
              TextField(
                  autofocus: true, style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                  padding: EdgeInsets.only(
                top: 10.0,
              )),

              Text("Duration", textAlign: TextAlign.left),
              TextField(
                  onChanged: (val) {
                    duration = val;
                  },
                  autofocus: true,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                  padding: EdgeInsets.only(
                top: 10.0,
              )),

              RaisedButton(
                color: Color(0xff603F83),
                onPressed: () {
                  _submitAdvance(place['slotID']);
                  Navigator.of(context).pop();
                }, //database
                child: Text("ADD",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              ), //raisedbutton
              SizedBox(width: 5.0, height: 10.0),
              RaisedButton(
                color: Color(0xff603F83),
                onPressed: () {
                  Navigator.of(context).pop();
                }, //database
                child: Text("CANCEL",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              ), //raisedbutton
            ], //widget
          ),
        ), //column
      ), //alerdialog
    );
  }
}

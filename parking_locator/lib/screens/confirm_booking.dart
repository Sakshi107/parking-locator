import 'package:flutter/material.dart';
import 'package:parking_locator/services/dbservice.dart';
import 'package:parking_locator/widgets/drawer.dart';

import 'package:parking_locator/constants.dart';

class ConfirmBooking extends StatefulWidget {
  final String carImage;
  final String bookingId;
  final String slotID;

  ConfirmBooking({this.slotID, this.carImage, this.bookingId});
  @override
  _ConfirmBookingState createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends State<ConfirmBooking> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    DbBookingMethods _dbmethod = DbBookingMethods();
    void _submit() async {
      var obj = await _dbmethod.confirmBook(widget.slotID, widget.bookingId);
      print(obj);
      if (obj["status"] == "SUCCESS") {
        Navigator.of(context).pushNamed('/my_booking');
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => ConfirmBooking(obj["carImage"])),
        // );
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.secColor,
          title: Text("ParkMe"),
        ),
        body: Center(
            child: Container(
                child: Card(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                      // side: BorderSide(width: 1, color: Colors.green),
                    ),
                    margin: EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Image.network(
                              widget.carImage,
                              height: height * 0.65,
                              width: width * 0.7,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
                                ),
                                //primary: kMainColor
                              ),
                              onPressed: () {
                                _submit();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text(
                                  'Confirm Booking',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ])))));
  }
}

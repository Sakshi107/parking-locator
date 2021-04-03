import 'package:flutter/material.dart';
import 'package:parking_locator/services/dbservice.dart';
import 'package:parking_locator/widgets/border_container.dart';
import 'package:parking_locator/widgets/drawer.dart';
import 'package:parking_locator/screens/confirm_booking.dart';

class PlaceDetails extends StatefulWidget {
  final String spotId;
  PlaceDetails({this.spotId});
  @override
  _PlaceDetailsState createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  DbMethods obj = DbMethods();
  DbBookingMethods _dbmethod = DbBookingMethods();

  var place;

  void _submit(slotID, lat, long,canBook) async {
    var obj = await _dbmethod.onSubmit(slotID, lat, long, canBook);
    print(obj);
    if (obj["STATUS"] == "SUCCESS") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConfirmBooking(
                slotID: slotID,
                carImage: obj["carImage"],
                bookingId: obj["bookingID"],)),
      );
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

  @override
  Widget build(BuildContext context) {
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
                      Center(
                        child: ElevatedButton(
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
                              "false"
                            );
                            print("go to confirm booking");
                          },
                          onLongPress: (){
                              print(place['Location']);
                            _submit(
                              place['slotID'],
                              place['Location']['coordinates'][0],
                              place['Location']['coordinates'][1],
                              "true"
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text(
                              'Book Now',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

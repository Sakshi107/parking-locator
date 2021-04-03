import 'package:flutter/material.dart';
import 'package:parking_locator/services/dbservice.dart';
import 'package:parking_locator/screens/slotdetails.dart';

class MySpots extends StatefulWidget {
  @override
  _MySpotsState createState() => _MySpotsState();
}

class _MySpotsState extends State<MySpots> {
  final db_methods = DbMethods();
  List<dynamic> spots;

  void getspots() async {
    List<dynamic> spots1;
    spots1 = await db_methods.mySpots();
    setState(() {
      spots = spots1;
    });
  }

  @override
  void initState() {
    getspots();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.of(context).pushNamed('/');
            }),
        title: Text('My Parking Spots'),
      ),
      body: Column(
        children: [
          // Text(spots[1]['address']),
          Expanded(
              child: (spots != null)
                  ? ListView.builder(
                      itemCount: spots.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.white,
                            elevation: 7,
                            child: InkWell(
                                borderRadius: BorderRadius.circular(15.0),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SlotDetails(
                                          spotID: spots[index]['slotID']),
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
                                        title: Text(spots[index]['address']),
                                        subtitle: Text("Start time: " +
                                            spots[index]['activeHours']
                                                ['start'] +
                                            "\nEnd time: " +
                                            spots[index]['activeHours']['end'] +
                                            "\nParking Type: " +
                                            spots[index]['parkingType'] +
                                            "   Charges: " +
                                            (spots[index]['chargesPerHour'])
                                                .toString()),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        );
                      })
                  : Center(
                      child: Text('No Parking Spot Found'),
                    )),
        ],
      ),
    );
  }
}

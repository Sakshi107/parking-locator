import 'package:flutter/material.dart';
import 'package:parking_locator/services/dbservice.dart';
import 'package:parking_locator/constants.dart';


class MyHistory extends StatefulWidget {
  @override
  _MyHistoryState createState() => _MyHistoryState();
}

class _MyHistoryState extends State<MyHistory> {
  final db_methods = DbMethods();
  List<dynamic> history;

  void gethistory() async {
    List<dynamic> result;
    result = await db_methods.userHistory();
    setState(() {
      history = result;
      print("My History ");
      print(history);
    });
  }

  @override
  void initState() {
    gethistory();
    // db_methods.userHistory();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Constants.secColor,
          title: Text('Add a Parking Spot'),
        ),
      body: Column(
        children: [
          // Text(spots[1]['address']),
          Expanded(
              child: (history != null)
                  ? ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.white,
                            elevation: 7,
                            child: Column(
                              children: [
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     Text(history[index]['address']),
                                //     Text("Start time: " +
                                //         history[index]['activeHours']['start']),
                                //     Text("End time: " +
                                //         history[index]['activeHours']['end']),
                                //     Row(
                                //       children: [
                                //         Text("Parking Type: " +
                                //             history[index]['parkingType']),
                                //         SizedBox(
                                //           width: width * 2 / 5,
                                //         ),
                                //         Text("Charges: " +
                                //             (history[index]['chargesPerHour'])
                                //                 .toString()),
                                //       ],
                                //     ),
                                //   ],
                                // )
                                ListTile(
                                  // isThreeLine: true,
                                  title: Text(history[index]['userID']),
                                  // subtitle: Text("Start time: " +
                                  //     history[index]['activeHours']
                                  //         ['start'] +
                                  //     "\nEnd time: " +
                                  //     history[index]['activeHours']['end'] +
                                  //     "\nParking Type: " +
                                  //     history[index]['parkingType'] +
                                  //     "   Charges: " +
                                  //     (history[index]['chargesPerHour'])
                                  //         .toString()),
                                )
                              ],
                            ),
                          ),
                        );
                      })
                  : Center(
                      child: Text('No Parking History Found'),
                    )),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:parking_locator/services/dbservice.dart';
import 'package:parking_locator/constants.dart';

class MyHistory extends StatefulWidget {
  @override
  _MyHistoryState createState() => _MyHistoryState();
}

class _MyHistoryState extends State<MyHistory> {
  final db_methods = DbMethods();
  final db2_methods = DbBookingMethods();

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

  void _checkout(id) {
    db2_methods.checkout(id);
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
        title: Text('My Bookings'),
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
                                GestureDetector(
                                    onTap: () {
                                      _checkout(history[index]['slotID']);
                                    },
                                    child: Container(
                                        child:

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
                                            // ,
                                            (history[index]['startTime'] ==
                                                    null)
                                                ? ListTile(
                                                    // isThreeLine: true,
                                                    subtitle: Text(
                                                        "Parking Type: " +
                                                            history[index]
                                                                    [
                                                                    'parkingLocation']
                                                                [
                                                                'parkingType']),
                                                    title: Text("Start time: " +
                                                            history[index][
                                                                    'startTime']
                                                                .toString() +
                                                            "\nParking Address: " +
                                                            history[index][
                                                                    'parkingLocation']
                                                                ['address'] +
                                                            "\nCharges per hour: " +
                                                            history[index][
                                                                        'parkingLocation']
                                                                    [
                                                                    'chargesPerHour']
                                                                .toString()
                                                        // "   Charges: " +
                                                        // (history[index]['parkingLocation']['chargesPerHour'])
                                                        // .toString()
                                                        ),
                                                  )
                                                : ListTile(
                                                    // isThreeLine: true,
                                                    subtitle: Text(
                                                        "Parking Type: " +
                                                            history[index]
                                                                    [
                                                                    'parkingLocation']
                                                                [
                                                                'parkingType']),
                                                    title: Text(
                                                        "Estimated Start time: " +
                                                            history[index][
                                                                    'estimatedStartTime']
                                                                .toString() +
                                                            "\nParking Address: " +
                                                            history[index][
                                                                    'parkingLocation']
                                                                ['address'] +
                                                            "\nCharges per hour: " +
                                                            history[index][
                                                                        'parkingLocation']
                                                                    [
                                                                    'chargesPerHour']
                                                                .toString()
                                                        // "   Charges: " +
                                                        // (history[index]['parkingLocation']['chargesPerHour'])
                                                        // .toString()
                                                        ),
                                                  )))
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

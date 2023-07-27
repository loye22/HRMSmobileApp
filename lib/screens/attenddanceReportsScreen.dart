import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/AppColors.dart';
import '../widgets/attendanceReportCell.dart';

class attenddanceReportsScreen extends StatefulWidget {
  static const routeName = '/attenddanceReportsScreen';

  const attenddanceReportsScreen({Key? key}) : super(key: key);

  @override
  State<attenddanceReportsScreen> createState() =>
      _attenddanceReportsScreenState();
}

class _attenddanceReportsScreenState extends State<attenddanceReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        Container(
          decoration: AppColors.decoration,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200.withOpacity(0.25),
          ),
        ),
        Positioned(
          bottom: 10,
          child: FutureBuilder(
            future: getAttendanceDataForCurrentUser(),
            builder: (ctx, snapShot) {
              if (snapShot.hasError) {
                return Center(
                  child: Text(
                    'error ${snapShot.error}',
                    style: TextStyle(fontSize: 50),
                  ),
                );
              }
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: MediaQuery.of(context).size.height - 80,
                  child: ListView.builder(
                    itemCount: snapShot.data!.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: attendanceReportCell(
                          workingHours: calculateWorkingHours(
                              snapShot.data![index]['checkInTimeStamp'],
                              snapShot.data![index]['checkOutTimeStamp']).toString(),
                          bransh:
                              snapShot.data![index]['BranshName'] ?? '404Error',
                          checkInTimeStamp: snapShot.data![index]
                                  ['checkInTimeStamp'] ??
                              '404Error',
                          checkOutTimeStamp: snapShot.data![index]
                                  ['checkOutTimeStamp'] ??
                              '404Error'),
                    ),
                  ),
                );
              }
            },
          ),
        )
      ]),
    );
  }

  Future<List<Map<String, dynamic>>> getAttendanceDataForCurrentUser() async {
    final String currentUserID = FirebaseAuth.instance.currentUser!.uid;

    if (currentUserID == null) {
      return [];
    }
    final CollectionReference attendanceCollection =
        FirebaseFirestore.instance.collection('attendance');

    try {
      QuerySnapshot querySnapshot = await attendanceCollection
          .where('uid', isEqualTo: currentUserID)
          .orderBy('checkInTimeStamp', descending: true)
          .get();

      List<Map<String, dynamic>> attendanceDataList = querySnapshot.docs
          .map((DocumentSnapshot documentSnapshot) =>
              documentSnapshot.data() as Map<String, dynamic>)
          .toList();
      return attendanceDataList;
    } catch (e) {
      print('Error getting attendance data: $e');
      return [];
    }
  }


  String calculateWorkingHours(String startTimeStamp, String endTimeStamp) {
    if(endTimeStamp == ''){
      return '0.0';
    }
    DateTime startDateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(startTimeStamp));
    DateTime endDateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(endTimeStamp));

    // Calculate the difference between startDateTime and endDateTime
    Duration workingHours = endDateTime.difference(startDateTime);

    // Calculate working hours in decimal format
    double workingHoursDecimal = workingHours.inMinutes / 60;

    // Format the result with three digits after the decimal point
    String formattedWorkingHours = workingHoursDecimal.toStringAsFixed(1);

    return formattedWorkingHours;
  }



}

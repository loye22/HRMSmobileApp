import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:mobilehrmss/models/AppColors.dart';

class attendanceReportCell extends StatelessWidget {
  final String checkInTimeStamp;
  final String checkOutTimeStamp;
  final String bransh;
  final String workingHours;

  const attendanceReportCell(
      {super.key,
      required this.checkInTimeStamp,
      required this.checkOutTimeStamp,
      required this.bransh,
      required this.workingHours});

  @override
  Widget build(BuildContext context) {
    List<String> monthNames = [
      '', // Leave an empty string at the 0th index to match the month number
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return Container(
      clipBehavior: Clip.antiAlias,
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width - 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade200.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 200,
            color: AppColors.staticColor,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateTime.fromMillisecondsSinceEpoch(
                        int.parse(this.checkInTimeStamp))
                    .day
                    .toString(),
                style:AppColors.myTextStyleWithSizde(MediaQuery.of(context).size.width * 0.09),
              ),
              Text( 
                monthNames[DateTime.fromMillisecondsSinceEpoch(
                        int.parse(this.checkInTimeStamp))
                    .month],
                style: AppColors.myTextStyleWithSizde(MediaQuery.of(context).size.width * 0.05),
              )
            ],
          ),
          SizedBox( 
            width: MediaQuery.of(context).size.width * 0.03,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  '${convertTimestampToTime(this.checkInTimeStamp)} to ${this.checkOutTimeStamp == '' ? '---' :  convertTimestampToTime(this.checkOutTimeStamp)} ',
                  style: AppColors.myTextStyleWithSizde(MediaQuery.of(context).size.width * 0.05),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.staticColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(this.bransh,
                      style:AppColors.myTextStyleWithSizde(MediaQuery.of(context).size.width * 0.05),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          ),
          Expanded(
            child: Text('${this.workingHours}hours',
                style: AppColors.myTextStyleWithSizde(MediaQuery.of(context).size.width * 0.04)),
          )
        ],
      ),
    );
  }

  String convertTimestampToTime(String timestamp) {
    int milliseconds = int.parse(timestamp);
    DateTime date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    String formattedTime = DateFormat('hh:mm').format(date);
    return formattedTime;
  }
}

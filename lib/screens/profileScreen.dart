import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/AppColors.dart';

class profileScreen extends StatefulWidget {
  static const routeName = '/profileScreen';

  //const profileScreen({Key? key}) : super(key: key);

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: AppColors.decoration,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200.withOpacity(0.25),
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
                width: MediaQuery.of(context).size.width - 50,
                height: MediaQuery.of(context).size.height - 80,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(30)),
                child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FutureBuilder(
                          future: getEmployeeData(),
                          builder: (ctx, snapShot) {
                            if (snapShot.hasError) {
                              return Center(child: Text('error 404'));
                            }
                            if (snapShot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 40,
                                              backgroundImage:
                                                  NetworkImage(snapShot.data!['photo']),
                                            ),
                                            SizedBox(height: 10,),
                                            Text(snapShot.data!['userName'] ,style: TextStyle(fontSize: 24), ) ,
                                            Row(
                                              children: [

                                                IconButton(onPressed: () async {
                                                  Navigator.of(context).pop();
                                                }, icon:Icon(Icons.arrow_back_outlined )) ,
                                                IconButton(onPressed: () async {
                                                  try {
                                                    await FirebaseAuth.instance.signOut();
                                                    Navigator.of(context).pop();
                                                    print('User logged out successfully.');
                                                  } catch (e) {
                                                    print('Error occurred while logging out: $e');
                                                  }
                                                }, icon:Icon(Icons.logout )),

                                              ],
                                            ) ,

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  _buildPersonalInfoItem(
                                      'Position', snapShot.data!['position']),
                                  FutureBuilder(
                                      future: getDepartmentTitle(
                                          snapShot.data!['departmentID']),
                                      builder: (ctx, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'),
                                          );
                                        } else {
                                          final depName = snapshot.data;
                                          // print(depName);
                                          return _buildPersonalInfoItem(
                                              'Depatment',
                                              depName != null
                                                  ? depName
                                                  : "not Found 404 error");
                                        }
                                      }),
                                  _buildPersonalInfoItem(
                                      'Date of Birth',  DateFormat('yyyy-MM-dd').format( snapShot.data!['dob'].toDate() ?? DateTime.now()) ),
                                  _buildPersonalInfoItem(
                                      'Email', 'employeeProfile.email'),
                                  _buildPersonalInfoItem(
                                      'Gender', 'employeeProfile.gender'),
                                  _buildPersonalInfoItem(
                                      'Hiring Date', DateFormat('yyyy-MM-dd').format( snapShot.data!['hiringDate'].toDate() ?? DateTime.now()) ),
                                  _buildPersonalInfoItem('Nationality',
                                      snapShot.data!['nationality']),
                                  _buildPersonalInfoItem('Phone Number',
                                      snapShot.data!['phoneNr']),
                                  /*FutureBuilder(
                            future: getWeekendTitle(employeeProfile.weekendId),
                            builder: (ctx, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else {
                                final weekendTitle = snapshot.data;
                                return _buildPersonalInfoItem(
                                  'Weekends',
                                  weekendTitle != null
                                      ? weekendTitle
                                      : "not Found 404 error",
                                );
                              }
                            })*/
                                ],
                              );
                            }
                          })),
                )),
          )
        ],
      ),
    );
  }

  Widget _buildPersonalInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Future<String> getWeekendTitle(String documentId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('weekEnd')
        .doc(documentId)
        .get();

    final title = snapshot.data()?['title'] ?? '';
    final days = (snapshot.data()?['days'] ?? [])
        .map<String>((day) => day.toString())
        .join(', ');

    return '$title: $days';
  }

  Future<String> getDepartmentTitle(String depId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Departments')
        .doc(depId)
        .get();

    final title = snapshot.data()?['title'] ?? '';

    return title;
  }

  Future<Map<String, dynamic>?> getEmployeeData() async {
    // Replace 'your_collection_path' with the actual collection path in your Firebase Firestore
    String collectionPath = 'Employee';
    String employeeId = '';

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        employeeId = user.uid;
      } else {
        throw Exception('User is not currently signed in.');
      }
      // Get the employee document using the provided ID
      DocumentSnapshot<Map<String, dynamic>> employeeSnapshot =
          await FirebaseFirestore.instance
              .collection(collectionPath)
              .doc(employeeId)
              .get();

      // Check if the employee document exists
      if (employeeSnapshot.exists) {
        print(employeeSnapshot.data()!);
        return employeeSnapshot.data()!;
      } else {
        throw Exception(
            'Employee document with ID $employeeId does not exist.');
      }
    } catch (e) {
      throw Exception('Failed to retrieve employee data: $e');
    }
  }
}
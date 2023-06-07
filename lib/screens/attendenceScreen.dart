import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:mobilehrmss/models/Dialog.dart';
import 'package:mobilehrmss/screens/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/AppColors.dart';
import '../test/camerratest.dart';
import '../widgets/background2.dart';
import '../widgets/distanceInfo.dart';

class attendenceScreen extends StatefulWidget {
  static const routeName = '/attendenceScreen';

  const attendenceScreen({Key? key}) : super(key: key);

  @override
  State<attendenceScreen> createState() => _attendenceScreenState();
}

class _attendenceScreenState extends State<attendenceScreen>
    with SingleTickerProviderStateMixin {
  final currentUser = FirebaseAuth.instance.currentUser;
  late Map<String, dynamic>? getAttendanceDataVar;
  late Map<String, dynamic>? currentBranshLocaion;
  late String currentBranshName;
  late Position empoyeeLocaion;
  TabController? _tabController;
  File? _capturedImage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: initt(),
          builder: (ctx, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Stack(
                children: [
                  Container(
                    decoration: AppColors.decoration,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.25),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              );
            }
            if (snapShot.hasError) {
              print(snapShot.error);
              return Center(
                  child: Center(child: Text(snapShot.error.toString())));
            } else {
              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
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
                    bottom: 10,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 20,
                      height: MediaQuery.of(context).size.height - 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            indicatorColor: Colors.blue,
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.black,
                            tabs: [
                              Tab(text: 'Check in-out'),
                              Tab(text: 'Reports'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                // check in - out bar
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    FutureBuilder(
                                      future: _determinePositionfff(),
                                      builder: (ctx, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return FlutterMap(
                                            options: MapOptions(
                                              center: latLng.LatLng(
                                                  double.parse(
                                                      this.currentBranshLocaion![
                                                          'latitude']),
                                                  double.parse(
                                                      this.currentBranshLocaion![
                                                          'longitude'])),
                                              zoom: 16.2,
                                            ),
                                            children: [
                                              TileLayer(
                                                urlTemplate:
                                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                userAgentPackageName:
                                                    'com.example.app',
                                              ),
                                              CircleLayer(
                                                circles: [
                                                  CircleMarker(
                                                    point: latLng.LatLng(
                                                        double.parse(
                                                            this.currentBranshLocaion![
                                                                'latitude']),
                                                        double.parse(
                                                            this.currentBranshLocaion![
                                                                'longitude'])),
                                                    // center of 't Gooi
                                                    radius: 100,
                                                    useRadiusInMeter: true,
                                                    color: Colors.green
                                                        .withOpacity(0.3),
                                                    borderColor: Colors.red
                                                        .withOpacity(0.7),
                                                    borderStrokeWidth: 2,
                                                  )
                                                ],
                                              ),
                                              MarkerLayer(
                                                markers: [
                                                  Marker(
                                                    point: latLng.LatLng(
                                                        double.parse(
                                                            this.currentBranshLocaion![
                                                                'latitude']),
                                                        double.parse(
                                                            this.currentBranshLocaion![
                                                                'longitude'])),
                                                    width: 80,
                                                    height: 80,
                                                    builder: (context) =>
                                                        Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          this.currentBranshName,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Icon(
                                                          Icons.location_on,
                                                          color: Colors.white,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // employee locaion
                                              MarkerLayer(
                                                markers: [
                                                  Marker(
                                                    point: latLng.LatLng(
                                                        this
                                                            .empoyeeLocaion
                                                            .latitude,
                                                        this
                                                            .empoyeeLocaion
                                                            .longitude),
                                                    width: 80,
                                                    height: 80,
                                                    builder: (context) =>
                                                        Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'You',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        Icon(
                                                          Icons.location_on,
                                                          color: Colors.red,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                    Positioned(
                                        bottom: 20,
                                        child: FutureBuilder(
                                            future:
                                                SharedPreferences.getInstance(),
                                            builder:
                                                (ctx, f) =>
                                                    f.connectionState ==
                                                            ConnectionState
                                                                .waiting
                                                        ? Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          )
                                                        : Column(
                                                            children: [
                                                              // if the shared pref is null ==> display check in button
                                                              // disply the CheckOut button otherwise
                                                              f.data!.getString(
                                                                          'key') ==
                                                                      null
                                                                  ?
                                                                  // check in button
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        // check in Algo
                                                                        // 1. check the internet coneection if false return
                                                                        // 2. Take photo for the emplyee if flase return
                                                                        // 3. Upload the check in record to the attendence collection
                                                                        // 4. create sharedPref named DocId which ref to the reocrd attendince ID so we
                                                                        // can use it to check out
                                                                            await f.data!.setString('key', 'sdsd');

                                                                        /*var image =
                                                      await captureSelfie(context);
                                                      if (image == null) {
                                                        MyDialog.showAlert(context,
                                                            "It is essential to inspect the photo.");
                                                        return;
                                                      }*/
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            70,
                                                                        height:
                                                                            50,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(30),
                                                                          color:
                                                                              Colors.greenAccent,
                                                                        ),
                                                                        child: Center(
                                                                            child: Text(
                                                                          'check in ',
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 14),
                                                                        )),
                                                                      ),
                                                                    )
                                                                  :
                                                                  //check out button
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        // check Out Algo
                                                                        // 1. check the internet coneection if false return
                                                                        // 2. Take photo for the emplyee if flase return
                                                                        // 3. get the doc IF from the sharedPrefernces
                                                                        // 4. UPDATE!!!!  the check out detales record in the attendence collection
                                                                            await f.data!.remove('key');
                                                                            var image =
                                                                            await captureSelfie(context);
                                                                        if (image ==
                                                                            null) {
                                                                          MyDialog.showAlert(
                                                                              context,
                                                                              "It is essential to inspect the photo.");
                                                                          return;
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            70,
                                                                        height:
                                                                            50,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(30),
                                                                          color:
                                                                              Colors.greenAccent,
                                                                        ),
                                                                        child: Center(
                                                                            child: Text(
                                                                          'check out  ',
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 14),
                                                                        )),
                                                                      ),
                                                                    ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  setState(
                                                                      () {});
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 70,
                                                                  height: 50,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                    color: Colors
                                                                        .greenAccent,
                                                                  ),
                                                                  child: Center(
                                                                      child:
                                                                          Text(
                                                                    'Refresh',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14),
                                                                  )),
                                                                ),
                                                              ),
                                                            ],
                                                          ))),
                                    Positioned(
                                        top: 50,
                                        child: distanceInfo(
                                          distance: calculateDistance(
                                              this.empoyeeLocaion.latitude,
                                              this.empoyeeLocaion.longitude,
                                              double.parse(
                                                  this.currentBranshLocaion![
                                                      'latitude']),
                                              double.parse(
                                                  this.currentBranshLocaion![
                                                      'longitude'])),
                                        ))
                                  ],
                                ),

                                // Documents Tab
                                Center(
                                  child: _capturedImage == null
                                      ? Text('reports')
                                      : Container(
                                          child: Image.file(_capturedImage!),
                                        ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
          }),
    );
  }

  Future<void> initt() async {
    final shiftcurrentDay = await getShiftsData(currentUser!.uid);
    this.currentBranshName = getBranchForCurrentDay(shiftcurrentDay!);
    final allLocaion = await fetchBranshesLocations();
    this.currentBranshLocaion = allLocaion.firstWhere(
      (location) => location['title'] == this.currentBranshName,
    );
    // loding the employee locaion detals
    this.empoyeeLocaion = await _determinePositionfff();
  }

  Future<Map<String, dynamic>?> getShiftsData(String employeeId) async {
    try {
      final employeeRef = FirebaseFirestore.instance.collection('Employee');
      final employeeSnapshot = await employeeRef.doc(employeeId).get();
      if (employeeSnapshot.exists) {
        //final email = employeeSnapshot.data()!['email'] ;
        final shiftsRef = employeeSnapshot.reference.collection('shifts');
        final QuerySnapshot shiftsSnapshot = await shiftsRef
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();
        if (shiftsSnapshot.docs.isNotEmpty) {
          final attendanceData =
              shiftsSnapshot.docs.first.data() as Map<String, dynamic>;
          getAttendanceDataVar = attendanceData;
          return attendanceData;
        }
      }
    } catch (e) {
      print('Error retrieving attendance data: $e');
    }
  }

  Future<Position> _determinePositionfff() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    // Retrieve the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    // print('Latitude: ${position.latitude} from the function');
    // print('Longitude: ${position.longitude} from funtion');
    //print(position.toString());
    print(position);
    return position;
  }

  Future<List<Map<String, dynamic>>> fetchBranshesLocations() async {
    List<Map<String, dynamic>> locations = [];

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('locations').get();

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> location = {
        'latitude': data['latitude'],
        'longitude': data['longitude'],
        'title': data['title'],
      };
      locations.add(location);
    });
    // print(locations);

    return locations;
  }

  String getBranchForCurrentDay(Map<String, dynamic> shiftsData) {
    // this function is for extrach the current bransh workind day
    // as the shift scedual
    DateTime now = DateTime.now();
    String currentDay = '';
    switch (now.weekday) {
      case DateTime.monday:
        currentDay = 'mon';
        break;
      case DateTime.tuesday:
        currentDay = 'tur';
        break;
      case DateTime.wednesday:
        currentDay = 'wed';
        break;
      case DateTime.thursday:
        currentDay = 'thu';
        break;
      case DateTime.friday:
        currentDay = 'fri';
        break;
      case DateTime.saturday:
        currentDay = 'sat';
        break;
      case DateTime.sunday:
        currentDay = 'sun';
        break;
      default:
        return ''; // Return empty string for an invalid day
    }

    if (shiftsData.containsKey('shifts')) {
      Map<String, dynamic> shifts = shiftsData['shifts'];

      if (shifts.containsKey(currentDay)) {
        String shiftDetails = shifts[currentDay];

        List<String> shiftParts = shiftDetails.split(' ');
        if (shiftParts.length >= 3) {
          String branchName = shiftParts.last;
          return branchName;
        }
      }
    }

    return ''; // Return empty string if no branch is found for the current day
  }

  // to user the camera
  Future<XFile?> captureSelfie(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    // Launch the camera app
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      _capturedImage = File(image.path);
      return image;
      // Do something with the captured image, e.g. save it or display it in an image widget
      // ...
    }
    return null;
  }

  // calc the disatance between the emplyee locaion
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Radius of the Earth in kilometers

    // Convert latitude and longitude to radians
    double latRad1 = degreesToRadians(lat1);
    double lonRad1 = degreesToRadians(lon1);
    double latRad2 = degreesToRadians(lat2);
    double lonRad2 = degreesToRadians(lon2);

    // Calculate the differences between coordinates
    double latDiff = latRad2 - latRad1;
    double lonDiff = lonRad2 - lonRad1;

    // Haversine formula
    double a = pow(sin(latDiff / 2), 2) +
        cos(latRad1) * cos(latRad2) * pow(sin(lonDiff / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c * 1000; // Convert to meters
    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart' as latLng;
import '../models/AppColors.dart';

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
  late Map<String, dynamic>? currentBranshLocaion ;
  late String currentBranshName ;
  late  Position empoyeeLocaion;
  TabController? _tabController;

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
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapShot.hasError) {
              return Center(child: Center(child: Text(snapShot.error.toString())));
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
                                FutureBuilder(
                                  future: _determinePositionfff(),
                                  builder: (ctx, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return FlutterMap(
                                        options: MapOptions(
                                          center: latLng.LatLng(
                                              double.parse(this.currentBranshLocaion!['latitude']),  double.parse(this.currentBranshLocaion!['longitude'])),
                                          zoom: 15.2,
                                        ),
                                        children: [
                                          TileLayer(
                                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                            userAgentPackageName: 'com.example.app',
                                          ),
                                          CircleLayer(
                                            circles: [
                                              CircleMarker(
                                                point: latLng.LatLng(
                                                    double.parse(this.currentBranshLocaion!['latitude']),  double.parse(this.currentBranshLocaion!['longitude'])),
                                                // center of 't Gooi
                                                radius: 200,
                                                useRadiusInMeter: true,
                                                color: Colors.green.withOpacity(0.3),
                                                borderColor: Colors.red.withOpacity(0.7),
                                                borderStrokeWidth: 2,
                                              )
                                            ],
                                          ),
                                          MarkerLayer(
                                            markers: [
                                              Marker(
                                                point: latLng.LatLng(
                                                    double.parse(this.currentBranshLocaion!['latitude']),  double.parse(this.currentBranshLocaion!['longitude'])),
                                                width: 80,
                                                height: 80,
                                                builder: (context) => Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(this.currentBranshName , style: TextStyle(color: Colors.white),)
                                                    ,
                                                    Icon(
                                                      Icons.location_on,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ) ,
                                          // employee locaion
                                          MarkerLayer(
                                            markers: [
                                              Marker(
                                                point: latLng.LatLng(
                                                    this.empoyeeLocaion.latitude, this.empoyeeLocaion.longitude),
                                                width: 80,
                                                height: 80,
                                                builder: (context) => Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('emplyeee' , style: TextStyle(color: Colors.red),)
                                                    ,
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


                                /*GestureDetector(
                                  onTap: () async {
                                    //final now = DateTime.now();
                                    //print(DateFormat('EEE').format(now));
                                    final x  = await  _determinePositionfff() ;
                                    print(x.toString() + "<<<<<<<<<<<<");
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppColors.color1, // Start color
                                          AppColors.color2, // End color
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(100) ,
                                      color: Color.fromRGBO(36,171,  105, 1),

                                    ),

                                    child: Center(child: Text('Check in' , style: TextStyle(color: Colors.white , fontSize: 17),)),

                                  ),
                                ),*/

                                // Documents Tab
                                Stack(
                                  children: [
                                    FlutterMap(
                                      options: MapOptions(
                                        center: latLng.LatLng(51.509364, -0.128928),
                                        zoom: 3.2,
                                      ),
                                      children: [
                                        TileLayer(
                                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                          userAgentPackageName: 'com.example.app',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
    this.currentBranshName =  getBranchForCurrentDay(shiftcurrentDay!);
    final allLocaion  = await fetchBranshesLocations();
    this.currentBranshLocaion = allLocaion.firstWhere(
          (location) => location['title'] == this.currentBranshName,);
    // loding the employee locaion detals
    this.empoyeeLocaion =await _determinePositionfff();




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



}

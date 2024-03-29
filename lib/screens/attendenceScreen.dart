import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:mobilehrmss/models/Dialog.dart';
import 'package:mobilehrmss/screens/splashScreen.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/AppColors.dart';
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
  late double distance;
  late Map<String, dynamic> weekSchedual;
  String userName = '';

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if(mounted) {
      super.setState(fn);
    }
  }
  @override

  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // 1.1
    bool  myValue = await getDataWithExpiry();
    if (myValue) {
      // The value has expired so delete the 'key' shrePreff
      try {
        SharedPreferences f =  await SharedPreferences.getInstance() ;
      await f.remove('key');}
          catch(e){

          }

    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


    return Scaffold(
        key: _scaffoldKey,

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
                  child: Stack(
                children: [
                  Container(
                    decoration: AppColors.decoration,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.25),
                    ),
                  ),
                  Center(
                      child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: MediaQuery.of(context).size.height - 550,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text(
                        snapShot.error.toString(),
                        style: AppColors.textStyle1,
                      ),
                    ),
                  )),
                ],
              ));
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
                      height: MediaQuery.of(context).size.height - 100,
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
                              Tab(text: 'Week Schedual'),
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
                                        }
                                        if (snapShot.hasError) {
                                          print(snapShot.error);
                                          return Center(
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    decoration: AppColors.decoration,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.shade200.withOpacity(0.25),
                                                    ),
                                                  ),
                                                  Center(
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width - 50,
                                                        height: MediaQuery.of(context).size.height - 550,
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey.shade200.withOpacity(0.25),
                                                            borderRadius: BorderRadius.circular(30)),
                                                        child: Center(
                                                          child: Text(
                                                            snapShot.error.toString(),
                                                            style: AppColors.textStyle1,
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ));
                                        }

                                        else {
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
                                      child: Column(
                                        children: [
                                          FutureBuilder(
                                            future:
                                                SharedPreferences.getInstance(),
                                            builder: (ctx, f) =>
                                                f.connectionState ==
                                                        ConnectionState.waiting
                                                    ? Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    :
                                                            isLoading
                                                                ? Center(
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  )
                                                                :
                                                                   Column(
                                                                      children: [
                                                                        // if the shared pref is null ==> display check in button
                                                                        // disply the CheckOut button otherwise
                                                                        f.data!.getString('key') ==
                                                                                null
                                                                            ?
                                                                            // check in button
                                                                            GestureDetector(
                                                                                onTap: () async {
                                                                                  // check in Algo
                                                                                  // 1. check the internet coneection if false return
                                                                                  // 2. Take photo for the emplyee if flase return
                                                                                  // 3. Upload the check in record to the attendence collection
                                                                                  // 4. create sharedPref named DocId which ref to the reocrd attendince ID so we
                                                                                  // can use it to check out
                                                                                  // 5. create sharedPref namde expiresAt where we store the expDuration
                                                                                  //  int expiryTimestamp = DateTime.now().millisecondsSinceEpoch + expiryDuration
                                                                                  // so we can check this to reset the check in/out proceder

                                                                                  try {
                                                                                    this.isLoading = true;
                                                                                    if(mounted){
                                                                                      setState(() {});
                                                                                    }


                                                                                    //1.
                                                                                    bool connectionStatus = await InternetConnectionChecker().hasConnection;
                                                                                    if (!connectionStatus) {
                                                                                      MyDialog.showAlert(context, 'Plase check you connection and try again !');
                                                                                      print( 'Plase check you connection and try again !');
                                                                                    //  AppColors.showCustomSnackbar(context,'Plase check you connection and try again !' );
                                                                                      isLoading = false;
                                                                                      if(mounted) {
                                                                                        setState(() {});
                                                                                      }
                                                                                      return;
                                                                                    }

                                                                                    //2.
                                                                                    XFile? image = await captureSelfie(context);
                                                                                    if (image == null) {
                                                                                      MyDialog.showAlert(context, "It is essential to inspect the photo.");
                                                                                      print("It is essential to inspect the photo.");
                                                                                     // AppColors.showCustomSnackbar(context, "It is essential to inspect the photo.");
                                                                                      isLoading = false;
                                                                                      if(mounted) {
                                                                                        setState(() {});
                                                                                      }
                                                                                      return;
                                                                                    }

                                                                                    // uploading the photo firebase
                                                                                    FirebaseStorage storage = FirebaseStorage.instance;
                                                                                    // Create a unique filename for the image using the current timestamp
                                                                                    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + "_" + randomAlphaNumeric(8).toString();
                                                                                    // Specify the folder path in Firebase Storage
                                                                                    String folderPath = 'attendance';
                                                                                    // Upload the file to Firebase Storage in the specified folder
                                                                                    TaskSnapshot snapshot = await storage.ref().child('$folderPath/$fileName').putFile(File(image.path));
                                                                                    // Get the download URL of the uploaded image
                                                                                    String downloadUrl = await snapshot.ref.getDownloadURL();

                                                                                    //uploading the the check in data to firebase attendice collection
                                                                                    FirebaseFirestore firestore = FirebaseFirestore.instance;
                                                                                    // Define a Firestore collection reference
                                                                                    CollectionReference attendanceCollection = firestore.collection('attendance');
                                                                                    // Create a document with a unique ID
                                                                                    DocumentReference documentRef = attendanceCollection.doc();

                                                                                    await documentRef.set({
                                                                                      'uid': FirebaseAuth.instance.currentUser!.uid,
                                                                                      'email': FirebaseAuth.instance.currentUser!.email,
                                                                                      'name': this.userName,
                                                                                      'scedual': getAttendanceDataVar,
                                                                                      'BranshName': this.currentBranshName,
                                                                                      'checkInTimeStamp': DateTime.now().millisecondsSinceEpoch.toString(),
                                                                                      'checkInLat': this.empoyeeLocaion.latitude.toString(),
                                                                                      'checkInLong': this.empoyeeLocaion.longitude.toString(),
                                                                                      'checkInIsHeIn': (this.distance <= 15).toString(),
                                                                                      'checkInPhoto': downloadUrl,
                                                                                      'checkOutTimeStamp': "",
                                                                                      'checkOutLat': "",
                                                                                      'checkOutLong': "",
                                                                                      'checkOutIsHeIn': "",
                                                                                      'checkOutPhoto': "",
                                                                                    });
                                                                                    //4.
                                                                                    await f.data!.setString('key', documentRef.id);
                                                                                    //5.
                                                                                    await f.data!.setInt('expiresAt', Duration(hours: 16).inMilliseconds  + DateTime.now().millisecondsSinceEpoch);


                                                                                    //  Navigator.of(context).pop();

                                                                                    //MyDialog.showAlert(context, 'Check-in successful');
                                                                                    AppColors.showCustomSnackbar(context,  'Check-in successful');
                                                                                    Navigator.of(context).pop();


                                                                                  } catch (e) {
                                                                                    print(e);
                                                                                    //MyDialog.showAlert(context, e.toString());
                                                                                    AppColors.showCustomSnackbar(context, 'error ${e.toString()}');
                                                                                  }
                                                                                  finally{
                                                                                    this.isLoading = false;
                                                                                    if(mounted){
                                                                                      setState(() {});
                                                                                    }

                                                                                  }
                                                                                },
                                                                                child: Container(
                                                                                  width: MediaQuery.of(context).size.width * 0.4,
                                                                                  height: MediaQuery.of(context).size.height *0.09,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(30),
                                                                                    color: Colors.greenAccent,
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(12.0),
                                                                                    child: Center(
                                                                                        child: Text(
                                                                                      'check in ',
                                                                                      style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width *0.05),
                                                                                    )),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            :
                                                                            //check out button
                                                                            GestureDetector(
                                                                                onTap: () async {
                                                                                  // check Out Algo
                                                                                  // 1. check the internet coneection if false return
                                                                                  // 2. Take photo for the emplyee if flase return
                                                                                  // 3. get the doc Id from the sharedPrefernces
                                                                                  // 4. UPDATE!!!!  the check in detales record in the attendence collection
                                                                                  // 5. remove the shared
                                                                                  try {
                                                                                    this.isLoading = true;
                                                                                    if(mounted) {
                                                                                      setState(() {});
                                                                                    }

                                                                                    //1.
                                                                                    bool connectionStatus = await InternetConnectionChecker().hasConnection;
                                                                                    if (!connectionStatus) {
                                                                                      MyDialog.showAlert(context, 'Plase check you connection and try again !');
                                                                                      print('Plase check you connection and try again !');
                                                                                     // AppColors.showCustomSnackbar(context,'Plase check you connection and try again !' );
                                                                                      isLoading = false;
                                                                                      if(mounted) {
                                                                                        setState(() {});
                                                                                      }
                                                                                      return;
                                                                                    }




                                                                                    //2.
                                                                                    XFile? image = await captureSelfie(context);
                                                                                    if (image == null) {
                                                                                      MyDialog.showAlert(context, "It is essential to inspect the photo in Check out.");
                                                                                      print("It is essential to inspect the photo in Check out.");
                                                                                     /* AppColors.showCustomSnackbar(
                                                                                          context,"It is essential to inspect the photo in Check out." );*/
                                                                                      isLoading = false;
                                                                                      if(mounted){
                                                                                      setState(() {});}
                                                                                      return;
                                                                                    }

                                                                                    // uploading the photo firebase
                                                                                    FirebaseStorage storage = FirebaseStorage.instance;
                                                                                    // Create a unique filename for the image using the current timestamp
                                                                                    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + "_" + randomAlphaNumeric(8).toString();
                                                                                    // Specify the folder path in Firebase Storage
                                                                                    String folderPath = 'attendance';
                                                                                    // Upload the file to Firebase Storage in the specified folder
                                                                                    TaskSnapshot snapshot = await storage.ref().child('$folderPath/$fileName').putFile(File(image.path));
                                                                                    // Get the download URL of the uploaded image
                                                                                    String downloadUrl = await snapshot.ref.getDownloadURL();
                                                                                    String? docId = f.data!.getString('key');
                                                                                    Position checkOutPostion = await _determinePositionfff();

                                                                                    // Define the document reference
                                                                                    FirebaseFirestore firestore = FirebaseFirestore.instance;
                                                                                    DocumentReference documentRef = firestore.collection('attendance').doc(docId);

                                                                                    // Update the specific fields
                                                                                    await documentRef.update({
                                                                                      'checkOutTimeStamp': DateTime.now().millisecondsSinceEpoch.toString(),
                                                                                      'checkOutLat': checkOutPostion.latitude.toString(),
                                                                                      'checkOutLong': checkOutPostion.longitude.toString(),
                                                                                      'checkOutIsHeIn': (this.calculateDistance(checkOutPostion.latitude, checkOutPostion.longitude, double.parse(this.currentBranshLocaion!['latitude']), double.parse(this.currentBranshLocaion!['longitude'])) <= 100 ? true : false).toString(),
                                                                                      'checkOutPhoto': downloadUrl,
                                                                                    });

                                                                                    //5.
                                                                                    await f.data!.remove('key');

                                                                                    AppColors.showCustomSnackbar(
                                                                                        context,'Check-out successful' );
                                                                                  } catch (e) {
                                                                                    print(e);
                                                                                //    MyDialog.showAlert(context, e.toString());
                                                                                    AppColors.showCustomSnackbar(
                                                                                        context,'Error: ${e.toString()}' );
                                                                                  }
                                                                                  finally{
                                                                                    isLoading = false;
                                                                                    if(mounted){
                                                                                      setState(() {});
                                                                                    }
                                                                                  }

                                                                                  // await f.data!.remove('key');
                                                                                },
                                                                                child: Container(
                                                                                  width: MediaQuery.of(context).size.width * 0.4,
                                                                                  height: MediaQuery.of(context).size.height *0.09,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(30),
                                                                                    color: Colors.greenAccent,
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(12.0),
                                                                                    child: Center(
                                                                                        child: Text(
                                                                                      'check out',
                                                                                      style: TextStyle(color: Colors.white, fontSize:MediaQuery.of(context).size.width *0.05,),
                                                                                    )),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                      ],
                                                                    ),

                                          ),
                                          /*GestureDetector(
                                            onTap: () async {
                                              setState(() {});
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.greenAccent,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Center(
                                                    child: Text(
                                                  'Refresh',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                )),
                                              ),
                                            ),
                                          )*/
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                        top: 50,
                                        child: distanceInfo(
                                          distance:
                                              this.distance.roundToDouble(),
                                        ))
                                  ],
                                ),

                                // Documents Tab
                                Center(
                                    child: DataTable2(
                                  columnSpacing: 12,
                                  horizontalMargin: 12,
                                  sortColumnIndex: 0,
                                  minWidth:
                                      MediaQuery.of(context).size.width - 200,
                                  columns: [
                                    DataColumn2(
                                      label: Text('Day'),
                                    ),
                                    DataColumn(
                                      label: Text('Shift'),
                                    ),
                                  ],
                                  rows: this
                                      .weekSchedual['shifts']
                                      .entries
                                      .map<DataRow>((entry) {
                                    String day = entry.key;
                                    String shift = entry.value;
                                    String shiftTimeRange =
                                        shift.split(' ').sublist(1).join(' ');

                                    String branch = shift.endsWith('Off')
                                        ? 'OFF'
                                        : shift.split(' ').last;
                                    return DataRow(cells: [
                                      DataCell(Text(getDayName(day))),
                                      DataCell(Text(shiftTimeRange == ''
                                          ? "off"
                                          : shiftTimeRange)),
                                    ]);
                                  }).toList(),
                                ))
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
    // The alogrithm from check in-out
    // 1. get the newiest shift Scedual for this employee , in case its null rasise exaption "No scedual shift found for you ,  please contact your HR "
    // 2. extract the bransh name from the shiftdata for the current day since each employee may works in at diffrint branshes
    // 3. load all branshes names with there locaions as List<Map<String, dynamic>> , in case its null  load the defalt locaion
    // 4. load the loacion for the bransh that we get at step No.2 by looking for him in the list we loaded in stpep No.3
    // 5. load current employee loacion
    // 6. calcuate the distance between employee location and the bransh location in oreder to cehck it less than 100

    // .1
    final shiftcurrentDay = await getShiftsData(currentUser!.uid);
    shiftcurrentDay == null
        ? throw Exception(
            'No scedual shift found for you, please contact your HR!')
        : print('');
    this.weekSchedual = shiftcurrentDay!;
    this.weekSchedual['shifts'].remove('bransh');

    // 2.
    this.currentBranshName = getBranchForCurrentDay(shiftcurrentDay!);

    // 3.
    final allLocaion = await fetchBranshesLocations();

    // .4
    try {
      this.currentBranshLocaion = allLocaion.firstWhere(
          (location) => location['title'] == this.currentBranshName);
    } catch (e) {
      this.currentBranshLocaion =
          allLocaion.firstWhere((location) => location['title'] == "Defalt");
    }

    // .5
    this.empoyeeLocaion = await _determinePositionfff();

    // .6
    this.distance = calculateDistance(
        this.empoyeeLocaion.latitude,
        this.empoyeeLocaion.longitude,
        double.parse(this.currentBranshLocaion!['latitude']),
        double.parse(this.currentBranshLocaion!['longitude']));
    // loding the employee locaion detals
  }


  // this function is to check the expiry pertiod if it more that 10 hors will delete the check out shrepreffrence
  Future<bool> getDataWithExpiry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the value and the expiry timestamp
    int expiryTimestamp = prefs.getInt('expiresAt') ?? 0;
    print(expiryTimestamp.toString() + ':   expiryTimestamp');
    print( DateTime.now().millisecondsSinceEpoch.toString() + ': datetime.mnow');

    // Check if the data is expired
    if (expiryTimestamp > 0 && DateTime.now().millisecondsSinceEpoch > expiryTimestamp ) {
      // Data has expired; delete it and return null
      prefs.remove('expiresAt');
      return true ;
    }
    return false;
  }


  show(BuildContext context){
    var dialog = Dialog(
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: "Insira o número de telefone",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2.0)))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancelar")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Aceitar"))
                ],
              )
            ],
          ),
        ),
      ),
    );}

  Future<Map<String, dynamic>?> getShiftsData(String employeeId) async {
    try {
      final employeeRef = FirebaseFirestore.instance.collection('Employee');
      final employeeSnapshot = await employeeRef.doc(employeeId).get();
      if (employeeSnapshot.exists) {
        this.userName = employeeSnapshot.data()!['userName'];
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

  String getDayName(String day) {
    switch (day) {
      case 'mon':
        return 'Monday';
      case 'tur':
        return 'Tuesday';
      case 'wed':
        return 'Wednesday';
      case 'thu':
        return 'Thursday';
      case 'fri':
        return 'Friday';
      case 'sat':
        return 'Saturday';
      case 'sun':
        return 'Sunday';
      default:
        return '';
    }
  }
}

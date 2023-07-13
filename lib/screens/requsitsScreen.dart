import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobilehrmss/main.dart';
import 'package:mobilehrmss/models/Dialog.dart';
import 'package:mobilehrmss/models/yesNoDialog.dart';
import 'package:mobilehrmss/screens/homeScreen.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../models/AppColors.dart';
import '../widgets/buildDonutChart.dart';
import '../widgets/button2.dart';

class requsitsScreen extends StatefulWidget {
  static const routeName = '/requsitsScreen';

  const requsitsScreen({Key? key}) : super(key: key);

  @override
  State<requsitsScreen> createState() => _requsitsScreenState();
}

class _requsitsScreenState extends State<requsitsScreen> {
  Map<String, String> requists = {};
  String selectedOption = '';
  int counter = 1;
  bool isLoading = false;
  List<String> timeOffTitiles = [];
  Map<String, dynamic>? timeOffDetaks = {};
  DateTime? sDate = null;
  DateTime? eDate = null;
  File? file = null;

  String? fileName = null;

  @override
  Widget build(BuildContext context) {
    late Widget widgetToDisplay;
    switch (counter) {
      case 1:
        // first screen
        widgetToDisplay = Container(
            width: MediaQuery.of(context).size.width - 50,
            height: MediaQuery.of(context).size.height - 80,
            decoration: BoxDecoration(
                color: Colors.grey.shade200.withOpacity(0.55),
                borderRadius: BorderRadius.circular(30)),
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) =>
                          Column(
                        children: [
                          Column(
                            children: this
                                .requists
                                .keys
                                .map((e) => ListTile(
                                      title: Text(e),
                                      leading: Radio<String>(
                                        value: e,
                                        groupValue: selectedOption,
                                        onChanged: (value) async {
                                          setState(() {
                                            selectedOption = value!;
                                          });
                                        },
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  )),
            ));
        break;
      case 2:
        // 2.1 let the employee selate the start and end dates and calc the days
        // 2.2  Check if the the employee has enough days as he requisted if yes send the requsit otherwise display
        widgetToDisplay = StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => Container(
            width: MediaQuery.of(context).size.width - 50,
            height: MediaQuery.of(context).size.height - 50,
            decoration: BoxDecoration(
                color: Colors.grey.shade200.withOpacity(0.55),
                borderRadius: BorderRadius.circular(30)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DonutChartWidget(
                    totalDays: timeOffDetaks!["duration"] != null
                        ? double.parse(timeOffDetaks!["duration"])
                        : 0.0,
                    usedDays: timeOffDetaks!["consume"] != null
                        ? double.parse(timeOffDetaks!["consume"])
                        : 0.0,
                    txt: timeOffDetaks!["title"] != null
                        ? timeOffDetaks!["title"]
                        : "error",
                    color: Colors.blue,
                  ),
                  Container(
                    child: SfDateRangePicker(
                      onSelectionChanged: _onSelectionChanged,
                      selectionMode: DateRangePickerSelectionMode.range,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  this.fileName != null
                      ? Container(
                          height: 40,
                          width: double.infinity,
                          //   decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.attachment),
                                Text(this.fileName!),
                                IconButton(
                                    onPressed: () {
                                      this.file = null;
                                      this.fileName = null;
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();
                        if (result != null) {
                          this.file = File(result.files.single.path!);
                          this.fileName = result.files.single.name;
                          setState(() {});
                        } else {
                          // User canceled the picker
                        }
                      } catch (e) {
                        MyDialog.showAlert(context, e.toString());
                      }
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColors.color1,
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Text(
                                  'Upload doc',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ))
                              ])),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                  ),
                ],
              ),
            ),
          ),
        );
        break;
      case 3:
        widgetToDisplay = Container(
          width: MediaQuery.of(context).size.width - 50,
          height: MediaQuery.of(context).size.height - 80,
          decoration: BoxDecoration(
              color: Colors.grey.shade200.withOpacity(0.55),
              borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: Text(selectedOption,
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        );
        break;

      default:
        widgetToDisplay = Container(
          child: Center(
            child: Text('error'),
          ),
        );
        break;
    }
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
        FutureBuilder(
            future: initt(),
            builder: (ctx, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapShot.hasError) {
                return Center(
                  child: Text(snapShot.error.toString()),
                );
              }

              return Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    widgetToDisplay,
                    isLoading
                        ? Positioned(
                            bottom: 10,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Positioned(
                            bottom: 10,
                            child: GestureDetector(
                                onTap: () async {
                                  // this button behaviour will change depend on the coundter var
                                  switch (this.counter) {
                                    case 1:
                                      //1. Check if the selected requist is from timeOff category if yes go to 2 else go to 3
                                      if (this.selectedOption.isEmpty) {
                                        MyDialog.showAlert(context,
                                            'Before proceeding, please ensure that you have selected the necessary requisites and then try again!');
                                        return;
                                      }
                                      // check if the requist is timeOff type or not
                                      this
                                              .timeOffTitiles
                                              .contains(selectedOption)
                                          ? this.counter = 2
                                          : this.counter = 3;
                                      this.timeOffDetaks = await checkHoliday(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          this.selectedOption);
                                      // 2. Check if the employee has this time off , if yes go to 2.1 else display msg saying please contact your HR
                                      // to assigen this type of timeOff
                                      if (timeOffDetaks == null &&
                                          this.counter != 3) {
                                        MyDialog.showAlert(context,
                                            "Unfortunately, you do not have this type of time off in your profile. Please contact your HR to request the assignment of this time off and try again later.");
                                        this.counter = 1;
                                        return;
                                      }
                                      setState(() {});
                                      break;
                                    case 2:
                                      // 2.2  Check if the the employee has enough days as he requisted if yes send the requsit otherwise display
                                      // you don't have enough days in your time off
                                      if (this.eDate == null ||
                                          this.sDate == null) {
                                        MyDialog.showAlert(context,
                                            'Please seclect date range!');
                                        return;
                                      }
                                      if (this.eDate != null &&
                                          this.sDate != null) {
                                        // calc how many days do the emplyee requisted
                                        int requsitedDayes = this
                                                .sDate!
                                                .difference(this.eDate!)
                                                .inDays
                                                .abs() +
                                            1;
                                        // calc the avalable days
                                        double avalableDays = double.parse(
                                                timeOffDetaks!["consume"]) -
                                            double.parse(
                                                timeOffDetaks!["duration"]);
                                        avalableDays = avalableDays.abs();
                                        if (requsitedDayes <= avalableDays) {
                                          isLoading = true;
                                          setState(() {});
                                          String url = '';
                                          // check if there is  file to upload
                                          if (this.file != null) {
                                            url = await uploadPDF(this.file!);
                                          }

                                          timeOffReq(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              this.requists[selectedOption]!,
                                              this.eDate!,
                                              this.sDate!,
                                              url,
                                            requsitedDayes.toString()

                                          );

                                          isLoading = false;
                                          setState(() {});
                                          AppColors.showCustomSnackbar(context, 'Your request has been sent successfully');

                                          return;
                                        } else {
                                          // the user exceed the avalable days in his profile
                                          MyDialog.showAlert(context,
                                              'The number of days off you requested exceeds the available days in your profile.');
                                        }
                                      }

                                      break;
                                    case 3:
                                      //3. send the requist (the non time off requists)
                                      MyAlertDialog.showConfirmationDialog(
                                          context,
                                          'Are you certain about sending the salary certificate request?',
                                          () async {
                                        isLoading = true;
                                        setState(() {});
                                        await nonTimeOffReq(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            this.requists[selectedOption]!);
                                        isLoading = false;
                                        setState(() {});
                                       /* MyDialog.showAlert(context,
                                            'Your request has been successfully sent.');*/
                                        AppColors.showCustomSnackbar(context, 'Your request has been sent successfully');
                                      }, () {
                                        Navigator.of(context).pop();
                                      });
                                      break;
                                    default:
                                      break;
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.color2,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      this.counter == 3
                                          ? 'Submit the requist'
                                          : 'Next',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                )),
                          )
                  ],
                ),
              );
            }),
      ]),
    );
  }

  Future<void> initt() async {
    // The alogrithem for seding requists
    // 1. Check if the selected requist is from timeOff category if yes go to 2 else go to 3
    // 2. Check if the employee has this time off , if yes go to 2.1 else display msg saying please contact your HR
    // to assigen this type of timeOff
    // 2.1 let the employee selate the start and end dates and calc the days
    // 2.2  Check if the the employee has enough days as he requisted if yes send the requsit otherwise display
    // you don't have enough days in your time off
    // 3. send the requist

    await getWorkflowData();
    await getTimeOffTitles();
  }

  Future<void> nonTimeOffReq(String userId, String workflowId) async {
    try {
      DateTime currentDate = DateTime.now();
      List<String> flowOrder = [];
      // Create the request document data
      Map<String, dynamic> requestData = {
        'eId': userId,
        'date': currentDate,
        'title': workflowId,
        'flow': {},
        'status': 'pending',
        'return':false ,
        'returnReason':''
      };
      // Retrieve the workflow document
      DocumentSnapshot workflowSnapshot = await FirebaseFirestore.instance
          .collection('workflow')
          .doc(workflowId)
          .get();

      // Check if the workflow document exists
      if (workflowSnapshot.exists) {
        // Retrieve the flow map from the workflow document
        Map<String, dynamic>? flowMap =
            workflowSnapshot.data() as Map<String, dynamic>?;
        // print(flowMap.toString()  + "<<<<<<<<");
        //print(flowMap!['flow']!.keys.toList()..sort());
        List<String> sortedKeys = flowMap!['flow'].keys.toList()..sort();
        Map<String, dynamic> sortedMap = {};
        for (var key in sortedKeys) {
          sortedMap[key] = flowMap['flow'][key];
        }

        requestData['flow'] = sortedMap;
        // Create the request document in the requests collection
        CollectionReference requestsCollection =
            FirebaseFirestore.instance.collection('requests');

        requestsCollection.add(requestData).catchError((error) {
          print('Failed to create request document: $error');
        });

        // print(requestData);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> timeOffReq(
    String userId,
    String workflowId,
      DateTime eData,
    DateTime sDate,
    String docUrl,
      String ReqistedDays
  ) async {
    try {
      DateTime currentDate = DateTime.now();
      List<String> flowOrder = [];

      // Create the request document data
      Map<String, dynamic> requestData = {
        'eId': userId,
        'date': currentDate,
        'title': workflowId,
        'flow': {},
        'status': 'pending',
        'eData': eData,
        'sDate': sDate,
        'docUrl': docUrl,
        'ReqistedDays':ReqistedDays,
        'return':false ,
        'returnReason':''
      };

      // Retrieve the workflow document
      DocumentSnapshot workflowSnapshot = await FirebaseFirestore.instance
          .collection('workflow')
          .doc(workflowId)
          .get();

      // Check if the workflow document exists
      if (workflowSnapshot.exists) {
        // Retrieve the flow map from the workflow document
        Map<String, dynamic>? flowMap =
            workflowSnapshot.data() as Map<String, dynamic>?;
        List<String> sortedKeys = flowMap!['flow'].keys.toList()..sort();
        Map<String, dynamic> sortedMap = {};
        for (var key in sortedKeys) {
          sortedMap[key] = flowMap['flow'][key];
        }

        requestData['flow'] = sortedMap;

        // Create the request document in the requests collection
        CollectionReference requestsCollection =
            FirebaseFirestore.instance.collection('requests');

        requestsCollection.add(requestData).catchError((error) {
          print('Failed to create request document: $error');
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, String>> getWorkflowData() async {
    // Replace 'workflow' with the actual collection name in your Firebase Firestore
    String collectionName = 'workflow';
    try {
      if (!this.requists.isEmpty) {
        return {};
      }
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection(collectionName).get();
      Map<String, String> workflowMap = {};
      for (QueryDocumentSnapshot<Map<String, dynamic>> docSnapshot
          in querySnapshot.docs) {
        String docId = docSnapshot.id;
        String title = docSnapshot.data()['title'];
        workflowMap[title] = docId;
      }
      this.requists = workflowMap;
      return workflowMap;
    } catch (e) {
      MyDialog.showAlert(context, 'error $e');
      throw Exception('Failed to retrieve workflow data: $e');
    }
  }

  Future<List<String>> getTimeOffTitles() async {
    List<String> titles = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('timeOff').get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No documents found in the "timeOff" collection.');
      }

      querySnapshot.docs.forEach((doc) {
        if (doc.exists) {
          dynamic x = doc.data() as Map<String, dynamic>;
          String title = x['title'];
          titles.add(title);
        }
      });
      this.timeOffTitiles = titles;
    } catch (e) {
      print('Error loading time off titles: $e');
    }

    return titles;
  }

  Future<Map<String, dynamic>?> checkHoliday(String uid, String title) async {
    try {
      // Access the "TimeOff" sub-collection for the employee with the given UID
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Employee')
          .doc(uid)
          .collection('TimeOff')
          .where('title', isEqualTo: title)
          .get();

      if (snapshot.docs.isEmpty) {
        return null; // The employee doesn't have the specified time off
      } else {
        final timeOffDoc = snapshot.docs.first;
        final timeOffData = timeOffDoc.data();
        return timeOffData as Map<String,
            dynamic>; // Return the attributes of the matching time off document
      }
    } catch (e) {
      print('Error checking holiday: $e');
      return null; // Return null on error
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    // TODO: implement your code here
    this.sDate = args.value.startDate;
    this.eDate = args.value.endDate;
    print(this.sDate.toString() + " " + this.eDate.toString());
    // print(args.value.startDate.difference(args.value.endDate).inDayes);
  }

  Future<String> uploadPDF(File pdfFile) async {
    try {
      // Create a reference to the desired storage location
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('requsitsDoc')
          .child('${DateTime.now().millisecondsSinceEpoch}.pdf');
      // Upload the file to Firebase Storage
      final UploadTask uploadTask = storageReference.putFile(pdfFile);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      // Get the download URL of the uploaded file
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading PDF: $e');
      return '';
    }
  }
}

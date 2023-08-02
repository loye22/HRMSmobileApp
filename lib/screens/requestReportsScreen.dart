import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobilehrmss/models/yesNoDialog.dart';

import '../models/AppColors.dart';

class requestReportsScreen extends StatefulWidget {
  static const routeName = '/requestReportsScreen';

  const requestReportsScreen({Key? key}) : super(key: key);

  @override
  State<requestReportsScreen> createState() => _requestReportsScreenState();
}

class _requestReportsScreenState extends State<requestReportsScreen> {
  Map<String, String> workFlow = {};

  bool returned = false;

  dynamic returnedData = 'text';

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
            top: 90,
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              height: MediaQuery.of(context).size.height - 160,
              decoration: BoxDecoration(
                  //color: Colors.grey.shade200.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(30)),
              child: this.returned
                  ? returnedWidget(returnedData: this.returnedData)
                  : FutureBuilder(
                      future: retrieveRequestsData(
                          FirebaseAuth.instance.currentUser!.uid),
                      builder: (ctx, snapShot) {
                        if (snapShot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapShot.hasError) {
                          return Center(child: Text(snapShot.error.toString()));
                        }
                        return DataTable2(
                            columnSpacing: 20,
                            horizontalMargin: 12,
                            sortColumnIndex: 0,
                            minWidth: MediaQuery.of(context).size.width - 200,
                            columns: [
                              DataColumn2(
                                label: Center(child: Text('Request')),
                              ),
                              DataColumn2(
                                label: Center(child: Text('Status')),
                              ),
                              DataColumn2(
                                label: Center(child: Text('Date')),
                              ),
                            ],
                            rows: snapShot.data!
                                .map((e) => DataRow2(
                                        onTap: () {
                                          if (e['return']) {
                                            this.returned = true;
                                            this.returnedData = e;
                                            setState(() {});
                                          }
                                        },
                                        cells: [
                                          DataCell(Center(
                                              child: Text(
                                                  this.workFlow[e['title']] ??
                                                      'N/A'))),
                                          DataCell(e['return']
                                              ? Center(
                                                  child: Text(
                                                      'Return for modification'))
                                              : Center(
                                                  child: Text(
                                                      e['status'] ?? 'N/A'))),
                                          DataCell(Center(
                                              child: Text(DateFormat('dd/MM/yy')
                                                      .format(
                                                          e['date'].toDate()) ??
                                                  'N/A')))
                                        ]))
                                .toList());
                      }),
            ),
          )
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> retrieveRequestsData(String eId) async {
    try {
      // Retrieve the request documents for the given eId
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('eId', isEqualTo: eId)
          .get();

      // Create a list to store the request data
      List<Map<String, dynamic>> requestDataList = [];

      // Iterate over the request documents
      querySnapshot.docs.forEach((doc) {
        // Convert each request document to a Map and add it to the list
        Map<String, dynamic> requestData = doc.data() as Map<String, dynamic>;
        requestDataList.add(requestData);
      });

      await getWorkflowData();
      return requestDataList;
    } catch (e) {
      print('Error retrieving requests data: $e');
      return [];
    }
  }

  Future<Map<String, String>> getWorkflowData() async {
    try {
      // Retrieve the documents from the "workflow" collection
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('workflow').get();

      // Create a map to store the workflow data
      Map<String, String> workflowData = {};

      // Iterate over the documents
      querySnapshot.docs.forEach((doc) {
        // Retrieve the document ID and "title" attribute
        String docId = doc.id;
        String title = (doc.data() as Map<String, dynamic>)['title'];

        // Add the data to the workflow map
        workflowData[docId] = title;
      });
      this.workFlow = workflowData;
      return workflowData;
    } catch (e) {
      print('Error retrieving workflow data: $e');
      return {};
    }
  }
}

class returnedWidget extends StatefulWidget {
  final dynamic returnedData;

  const returnedWidget({Key? key, required this.returnedData})
      : super(key: key);

  @override
  State<returnedWidget> createState() => _returnedWidgetState();
}

class _returnedWidgetState extends State<returnedWidget> {
  FilePickerResult? result = null;
  String filename = '';
  String reqisteddays = "";
  Timestamp from = Timestamp(10, 10);
  Timestamp to = Timestamp(10, 10);
  String newUrl = '';
  bool isLoading = false ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    reqisteddays = widget.returnedData['ReqistedDays'] ?? "----";
    from = widget.returnedData['sDate'] ?? Timestamp(10, 10);
    to = widget.returnedData['eData'] ?? Timestamp(10, 10);
    newUrl = widget.returnedData['docUrl'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    double h = 10;
    return FutureBuilder(
      future: getWorkflowTitles(),
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
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Requist type : ${snapShot.data![widget.returnedData['title']] ?? '404NotFound'}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Submission Date:\n ${widget.returnedData['date'].toDate()}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: h,
                ),
                Text(
                  'Requested Days: ${reqisteddays ?? '------'}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: h,
                ),
                widget.returnedData['sDate'] != null
                    ? Row(
                        children: [
                          Text(
                            'From: ${DateFormat('yyyy/MM/dd').format(from.toDate())}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            onPressed: () async {
                              Timestamp? newfrom =
                                  await pickDateAndConvertToTimestamp(context);
                              if (newfrom != null) {
                                this.from = newfrom;
                                setState(() {});
                              }
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          )
                        ],
                      )
                    : Text('-----',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                SizedBox(
                  height: h,
                ),
                widget.returnedData['eData'] != null
                    ? Row(
                        children: [
                          Text(
                            'To: ${DateFormat('yyyy/MM/dd').format(to.toDate())}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            onPressed: () async {
                              Timestamp? newfrom =
                                  await pickDateAndConvertToTimestamp(context);
                              if (newfrom != null) {
                                this.to = newfrom;
                                setState(() {});
                              }
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          )
                        ],
                      )
                    : Text('-----',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                SizedBox(
                  height: h,
                ),
                newUrl != ""
                    ? Row(
                        children: [
                          Text(
                            'No document were provided',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        this.isLoading ? Center(child: CircularProgressIndicator(),) :   IconButton(
                              onPressed: () async {
                                // Implement your upload logic here
                                result = await FilePicker.platform.pickFiles();
                                filename = result!.files.single.name;

                                //////////////////////
                                this.isLoading = true;
                                setState(() {});
                                String fileName = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                                Reference ref = FirebaseStorage
                                    .instance
                                    .ref()
                                    .child('workExp/$fileName');
                                UploadTask uploadTask =
                                ref.putFile(File(this
                                    .result!
                                    .files
                                    .first
                                    .path!));
                                TaskSnapshot storageTaskSnapshot =
                                await uploadTask
                                    .whenComplete(() {});
                                this.newUrl =
                                await storageTaskSnapshot.ref
                                    .getDownloadURL();

                                this.isLoading = false ;
                                setState(() {});




                                /////////////



                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ))
                        ],
                      )
                    : SizedBox.shrink(),
                SizedBox(
                  height: h,
                ),
                filename != ""
                    ? Container(
                        height: 40,
                        width: double.infinity,
                        //   decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.attachment),
                              Expanded(child: Text(filename)),
                              IconButton(
                                  onPressed: () {
                                    result = null;
                                    filename = '';
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
                Text(
                  'Reason \n ${widget.returnedData['returnReason']}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      MyAlertDialog.showConfirmationDialog(context,
                          "Before proceeding, please ensure that you have reviewed the reason for the return and update the necessary data. Take note that once you click 'Yes' to proceed, the action cannot be undone. If you have thoroughly read the request's return reason and have updated the required information, kindly click 'Yes.' Otherwise, if you wish to cancel or need more clarification, please click 'No.'",
                          () async {
                        // this algo is to update the requist data as following
                        //1. we need to get the doc ID meke quiery to find the document
                        // where  (eid and title and return ) attributes are identical for this user
                        //2. after we have the doc ID we simply update the data and flip the return attripute to false
                        //3.end
                        dynamic x = await FirebaseFirestore.instance
                            .collection('requests')
                            .where('eId', isEqualTo: widget.returnedData['eId'])
                            .where('title',
                                isEqualTo: widget.returnedData['title'])
                            .where('return', isEqualTo: true)
                            .get()
                            .then((QuerySnapshot snapshot) async {
                          //  print(snapshot.docs.first.id);
                          String docId = snapshot.docs.first.id;
                          await FirebaseFirestore.instance
                              .collection('requests')
                              .doc(docId)
                              .set(
                            {
                              'eData': this.to,
                              'sDate': this.from,
                              'docUrl': this.newUrl,
                              'return': false,
                            },
                            SetOptions(merge: true),
                          ).then((_) {
                            print('Request data updated successfully');
                            AppColors.showCustomSnackbar(context, 'Request data updated successfully');
                          }).catchError((error) {
                            print('Error updating request data: $error');
                            AppColors.showCustomSnackbar(context, 'Error updating request data: $error');
                          });
                        }).catchError((error) {
                          print('Error retrieving request data: $error');
                          AppColors.showCustomSnackbar(context, 'Error retrieving request data: $error');
                        });
                      }, () {});
                    },
                    child: Container(
                      width: 300,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Text(
                          'Resend the requist',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> getWorkflowTitles() async {
    Map<String, dynamic> workflowTitles = {};

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('workflow').get();

    snapshot.docs.forEach((doc) {
      Map<String, dynamic> s = doc.data() as Map<String, dynamic>;
      workflowTitles[doc.id] = s['title'];
    });

    return workflowTitles;
  }

  Future<Timestamp?> pickDateAndConvertToTimestamp(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final timestamp = Timestamp.fromDate(selectedDate);
      return timestamp;
    } else {
      // Return null or a default timestamp as needed
      return null;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobilehrmss/models/Dialog.dart';

import '../models/AppColors.dart';

class requsitsScreen extends StatefulWidget {
  static const routeName = '/requsitsScreen';

  const requsitsScreen({Key? key}) : super(key: key);

  @override
  State<requsitsScreen> createState() => _requsitsScreenState();
}

class _requsitsScreenState extends State<requsitsScreen> {
   Map<String, String> requists = {};

  String selectedOption = '';

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
        FutureBuilder(
            future: getWorkflowData(),
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

              return Positioned(
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
                          child: SingleChildScrollView(
                            child: StatefulBuilder(
                              builder: (BuildContext context,
                                      StateSetter setState) =>
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
                                      SizedBox(height: 100),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                              onTap: (){},
                                              child: Text('Next' , style: TextStyle( fontSize: 18 ),))
                                        ],
                                      )
                                    ],
                                  ),
                            ),
                          )),
                    )),
              );
            }),
      ]),
    );
  }

  Future<void> newRequist(String userId, String workflowId) async {
    try {
      print(userId + '    userId');
      print(workflowId + '        workflowId');
      DateTime currentDate = DateTime.now();
      List<String> flowOrder = [];
      // Create the request document data
      Map<String, dynamic> requestData = {
        'eId': userId,
        'date': currentDate,
        'title': workflowId,
        'flow': {},
        'status': 'pending',
        'ReqistedDays': "7"
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
}

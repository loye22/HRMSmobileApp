import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/AppColors.dart';

class requestReportsScreen extends StatefulWidget {
  static const routeName = '/requestReportsScreen';

  const requestReportsScreen({Key? key}) : super(key: key);

  @override
  State<requestReportsScreen> createState() => _requestReportsScreenState();
}

class _requestReportsScreenState extends State<requestReportsScreen> {
  Map<String, String> workFlow = {} ;


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
              child: FutureBuilder(
                  future: retrieveRequestsData(
                      FirebaseAuth.instance.currentUser!.uid),
                  builder: (ctx, snapShot) {
                    if(snapShot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    if (snapShot.hasError){
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
                          DataColumn(
                            label: Center(child: Text('Status')),
                          ),
                          DataColumn(
                            label: Center(child: Text('Date')),
                          ),
                        ],
                        rows: snapShot.data!
                            .map((e) => DataRow(cells: [
                                  DataCell(Center(child: Text(this.workFlow[e['title'] ]?? 'N/A'))),
                                  DataCell(Center(child: Text(e['status'] ?? 'N/A'))),
                                  DataCell(Center(child: Text(DateFormat('dd/MM/yy').format(e['date'].toDate()) ?? 'N/A')))
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
        String title = (doc.data() as Map<String,dynamic>)['title'] ;

        // Add the data to the workflow map
        workflowData[docId] = title;
      });
      this.workFlow = workflowData ;
      return workflowData;
    } catch (e) {
      print('Error retrieving workflow data: $e');
      return {};
    }
  }



}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobilehrmss/models/Dialog.dart';

import '../models/AppColors.dart';
import '../widgets/customNavigationBar.dart';

class workExpensesScreen extends StatefulWidget {
  static const routeName = '/workExpensesScreen';

  const workExpensesScreen({Key? key}) : super(key: key);

  @override
  State<workExpensesScreen> createState() => _workExpensesScreenState();
}

class _workExpensesScreenState extends State<workExpensesScreen> {
  TextEditingController _textEditingController = TextEditingController();
  FilePickerResult? result = null;

  String filename = '';

  bool isLoading = false;

  @override
  void dispose() {
    _textEditingController.dispose();
    this.result = null;
    this.filename = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              color: AppColors.color1, borderRadius: BorderRadius.circular(30)),
          child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)),
                      child: AlertDialog(
                        title: Text('Add work expinsise'),
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) =>
                                  Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _textEditingController,
                                decoration: InputDecoration(
                                  labelText: 'Title',
                                ),
                              ),
                              SizedBox(height: 20),
                              this.result != null
                                  ? Container(
                                      height: 40,
                                      width: double.infinity,
                                      //   decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.attachment),
                                            Expanded(
                                                child: Text(this.filename)),
                                            IconButton(
                                                onPressed: () {
                                                  this.result = null;
                                                  this.filename = '';
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
                              isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(height: 20),
                                        GestureDetector(
                                          child: Text('Add invoice'),
                                          onTap: () async {
                                            // Implement your upload logic here
                                            this.result = await FilePicker
                                                .platform
                                                .pickFiles();
                                            this.filename =
                                                result!.files.single.name;
                                            setState(() {});
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        GestureDetector(
                                          child: Text('Submit'),
                                          onTap: () async {
                                            try {
                                              if (_textEditingController.text ==
                                                  '') {
                                                MyDialog.showAlert(context,
                                                    'Please add title');
                                                return;
                                              }
                                              if (result == null) {
                                                MyDialog.showAlert(context,
                                                    'Please add invoice');
                                                return;
                                              }
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
                                              String downloadUrl =
                                                  await storageTaskSnapshot.ref
                                                      .getDownloadURL();

                                              User? user = FirebaseAuth
                                                  .instance.currentUser;
                                              String? uid = user?.uid;

                                              // Save download URL to Firestore
                                              FirebaseFirestore.instance
                                                  .collection('workExp')
                                                  .add({
                                                'eid': uid.toString(),
                                                'date': DateTime.now()
                                                    .millisecondsSinceEpoch
                                                    .toString(),
                                                'title': this
                                                    ._textEditingController
                                                    .text
                                                    .toString(),
                                                'status': false,
                                                'docUrl': downloadUrl,
                                              }).then((value) {
                                                this.isLoading = false ;
                                                Navigator.of(context).pop();

                                              return ;
                                              });

                                              // upload the data

                                             // Close the dialog
                                            } catch (e) {
                                              print(e.toString()  + ">>>>>>>>>>>>>>>>>>>>>>>>>>>");
                                              MyDialog.showAlert(
                                                  context, e.toString());
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );

                /*
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                if (result != null) {
                  File file = File(result.files.single.path!);


                  setState(() {});
                }*/
              },
              icon: Icon(Icons.add))),
      body: Stack(alignment: Alignment.center, children: [
        Container(
          decoration: AppColors.decoration,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200.withOpacity(0.25),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 50,
          height: MediaQuery.of(context).size.height - 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade200.withOpacity(0.55),
            borderRadius: BorderRadius.circular(30),
          ),
          child: FutureBuilder(
              future: retrieveAllWorkExpData(),
              builder: (ctx, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapShot.hasError) {
                  return Center(
                    child: Text('error: ${snapShot.error}'),
                  );
                }
                return DataTable2(
                    columnSpacing: 20,
                    horizontalMargin: 12,
                    sortColumnIndex: 0,
                    minWidth: MediaQuery.of(context).size.width - 200,
                    columns: [
                      DataColumn2(
                        label: Center(child: Text('Title')),
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
                              DataCell(
                                  Center(child: Text(e['title'] ?? 'N/A'))),
                              DataCell(Center(
                                  child: Text((e['status'] == true
                                          ? 'Accepted'
                                          : 'Pendding') ??
                                      'N/A'))),
                              DataCell(
                                Center(
                                  child: Text(DateFormat('dd/MM/yyyy')
                                      .format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              int.parse(e['date'])))
                                      .toString()),
                                ),
                              )
                            ]))
                        .toList());
              }),
        )
      ]),
    );
  }

  Future<List<Map<String, dynamic>>> retrieveAllWorkExpData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('workExp').get();
      List<Map<String, dynamic>> data = [];

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          Map<String, dynamic> documentData =
              documentSnapshot.data() as Map<String, dynamic>;
          data.add(documentData);
        }
      }

      return data;
    } catch (error) {
      print('Failed to retrieve data: $error');
      return [];
    }
  }
}

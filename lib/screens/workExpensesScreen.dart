import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _textEditingController.dispose();
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
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: AlertDialog(
                        title: Text('Upload File'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _textEditingController,
                              decoration: InputDecoration(
                                labelText: 'File Name',
                              ),
                            ),
                            SizedBox(height: 20),
                            GestureDetector(
                              child: Text('Upload'),
                              onTap: () async {
                                // Implement your upload logic here
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();
                                if (result != null) {
                                  File file = File(result.files.single.path!);


                                }
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
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
              borderRadius: BorderRadius.circular(30)),
        )
      ]),
    );
  }
}

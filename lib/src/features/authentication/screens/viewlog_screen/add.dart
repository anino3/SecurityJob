import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:visitors_log_project/src/constants/visitors.dart';

class Add extends StatefulWidget {
  const Add({super.key, required this.id});

  final String id;

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  late TextEditingController fullnamecontroller;
  late TextEditingController reasonVcontroller;
  late TextEditingController timeIncontroller;
  late TextEditingController timeOutcontroller;
  late TextEditingController condoOwnercontroller;
  late TextEditingController condoNumbercontroller;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  late String error;

  //TextEditingController timeinput = TextEditingController();

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future uploadFile() async {
    final path = 'files/${generateRandomString(5)}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');

    createVisitor(urlDownload);

    setState(() {
      uploadTask = null;
    });
  }

  @override
  void initState() {
    super.initState();
    fullnamecontroller = TextEditingController();
    reasonVcontroller = TextEditingController();
    timeIncontroller = TextEditingController();
    timeOutcontroller = TextEditingController();
    condoOwnercontroller = TextEditingController();
    condoNumbercontroller = TextEditingController();
    error = "";
    //  timeinput.text = "";
  }

  @override
  void dispose() {
    fullnamecontroller.dispose();
    reasonVcontroller.dispose();
    timeIncontroller.dispose();
    timeOutcontroller.dispose();
    condoOwnercontroller.dispose();
    condoNumbercontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Enlist Visitors",
            style: TextStyle(
              color: Colors.amberAccent,
              fontWeight: FontWeight.bold,
            )),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/image-4.png',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Scaffold(
            backgroundColor: Color.fromARGB(0, 255, 247, 247).withOpacity(0.7),
            body: ListView(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Color.fromARGB(142, 158, 158, 158),
                          ),
                          color: Colors.black,
                        ),
                        child: Center(
                          child:
                              (pickedFile == null) ? imgNotExist() : imgExist(),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          selectFile();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                        ),
                        label: const Text(
                          'Add Photo',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: TextField(
                          controller: fullnamecontroller,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                width: 1.5,
                                color: Colors.black,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Visitor's Full Name",
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: TextField(
                          controller: reasonVcontroller,
                          obscureText: false,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                width: 1.5,
                                color: Colors.black,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Reason for Visit",
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: TextField(
                          readOnly: true,
                          controller: timeIncontroller,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                width: 1.5,
                                color: Colors.black,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Time-In",
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );

                            if (pickedTime != null) {
                              String formattedTime =
                                  pickedTime.format(context).toString();

                              setState(() {
                                timeIncontroller.text = formattedTime;
                              });
                            } else {
                              print("Time is not selected");
                            }
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: TextField(
                          readOnly: true,
                          controller: timeOutcontroller,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                width: 1.5,
                                color: Colors.black,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Time-Out",
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );

                            if (pickedTime != null) {
                              String formattedTime =
                                  pickedTime.format(context).toString();

                              setState(() {
                                timeOutcontroller.text = formattedTime;
                              });
                            } else {
                              print("Time is not selected");
                            }
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: TextField(
                          controller: condoOwnercontroller,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                width: 1.5,
                                color: Colors.black,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Condo Owner Name",
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: TextField(
                          controller: condoNumbercontroller,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                width: 1.5,
                                color: Colors.black,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Condo Room Number",
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton(
                          onPressed: () {
                            if (fullnamecontroller.text == "" ||
                                reasonVcontroller.text == "" ||
                                timeIncontroller.text == "" ||
                                timeOutcontroller.text == "" ||
                                condoOwnercontroller.text == "" ||
                                condoNumbercontroller.text == "") {
                              //snackbar
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      duration: const Duration(seconds: 3),
                                      content: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Text(
                                            "Please Check Empty Fields",
                                          ),
                                          const Icon(
                                            Icons.warning,
                                            color: Colors.red,
                                          )
                                        ],
                                      )));
                            } else {
                              uploadFile();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: Colors.black,
                          ),
                          child: const Text(
                            'ENLIST',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.amberAccent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      buildProgress(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget imgExist() => Image.file(
        File(pickedFile!.path!),
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );

  Widget imgNotExist() => Image.asset(
        'assets/images/no-image.png',
        fit: BoxFit.cover,
      );

  Future createVisitor(urlDownload) async {
    final docVisitor = FirebaseFirestore.instance.collection('Visitor').doc();

    final newVisitor = Visitors(
      id: widget.id,
      visit_id: docVisitor.id,
      fullname: fullnamecontroller.text,
      reasonV: reasonVcontroller.text,
      timeIn: timeIncontroller.text,
      timeOut: timeOutcontroller.text,
      condoOwner: condoOwnercontroller.text,
      condoNumber: condoNumbercontroller.text,
      image: urlDownload,
    );

    final json = newVisitor.toJson();
    await docVisitor.set(json);

    final snackbar = SnackBar(
        duration: Duration(seconds: 2),
        margin: const EdgeInsets.only(bottom: 60),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        content: Row(children: [
          Expanded(
            child: Text(
              'Enlisted Successfully!',
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(width: 5),
          Icon(
            Icons.verified,
            color: Colors.black,
          ),
        ]));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);

    setState(() {
      fullnamecontroller.text = "";
      reasonVcontroller.text = "";
      timeIncontroller.text = "";
      timeOutcontroller.text = "";
      condoOwnercontroller.text = "";
      condoNumbercontroller.text = "";
      pickedFile = null;
    });
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return const SizedBox(
            height: 50,
          );
        }
      });
}

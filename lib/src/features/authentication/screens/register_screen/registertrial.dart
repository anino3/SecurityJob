import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:visitors_log_project/src/constants/users1.dart';

class RegisterTrial extends StatefulWidget {
  const RegisterTrial({super.key});

  @override
  State<RegisterTrial> createState() => _RegisterTrialState();
}

class _RegisterTrialState extends State<RegisterTrial> {
  late TextEditingController passwordcontroller;
  late TextEditingController namecontroller;
  late TextEditingController emailcontroller;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  late String error;

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

    registerUser(urlDownload);

    setState(() {
      uploadTask = null;
    });
  }

  @override
  void initState() {
    super.initState();

    passwordcontroller = TextEditingController();
    namecontroller = TextEditingController();
    emailcontroller = TextEditingController();
    error = "";
  }

  @override
  void dispose() {
    passwordcontroller.dispose();
    namecontroller.dispose();
    emailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Register Account',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(25),
        child: Card(
          elevation: 20,
          shadowColor: Colors.black,
          child: ListView(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        controller: emailcontroller,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.black,
                            ),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Enter email',
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
                        controller: passwordcontroller,
                        obscureText: true,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.black,
                            ),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Enter password',
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
                        controller: namecontroller,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.black,
                            ),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Enter name',
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
                          if (namecontroller.text == "" ||
                              passwordcontroller.text == "" ||
                              emailcontroller.text == "") {
                            //snackbar
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 3),
                                content: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
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
                          'CREATE',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
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

  Future registerUser(urlDownload) async {
    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );
      createUser(urlDownload);

      setState(() {
        error = "";
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        error = e.message.toString();
      });
      final snackbar = SnackBar(
          duration: Duration(seconds: 2),
          margin: const EdgeInsets.only(bottom: 60),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Row(children: [
            Expanded(
              child: Text(error),
            ),
            SizedBox(width: 5),
            Icon(
              Icons.error,
              color: Colors.green,
            ),
          ]));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
    Navigator.pop(context);
  }

  Future createUser(urlDownload) async {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;

    final docUser = FirebaseFirestore.instance.collection('Users').doc(userid);

    final newUser = Users1(
      id: docUser.id,
      password: passwordcontroller.text,
      email: emailcontroller.text,
      name: namecontroller.text,
      image: urlDownload,
    );

    final json = newUser.toJson();
    await docUser.set(json);
    final snackbar = SnackBar(
        duration: Duration(seconds: 2),
        margin: const EdgeInsets.only(bottom: 60),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        content: Row(children: [
          Expanded(
            child: Text('Registered Successfully!'),
          ),
          SizedBox(width: 5),
          Icon(
            Icons.verified,
            color: Colors.green,
          ),
        ]));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);

    Navigator.pop(context);
    FirebaseAuth.instance.signOut();
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

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:visitors_log_project/src/constants/visitors.dart';

class Update extends StatefulWidget {
  const Update({
    super.key,
    required this.visitors,
  });

  final Visitors visitors;

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  late TextEditingController fullnamectrl;
  late TextEditingController reasonVctrl;
  late TextEditingController timeInctrl;
  late TextEditingController timeOutctrl;
  late TextEditingController condoOwnerctrl;
  late TextEditingController condoNumberctrl;

  @override
  void initState() {
    super.initState();
    fullnamectrl = TextEditingController(
      text: widget.visitors.fullname,
    );
    reasonVctrl = TextEditingController(
      text: widget.visitors.reasonV,
    );
    timeInctrl = TextEditingController(
      text: widget.visitors.timeIn,
    );
    timeOutctrl = TextEditingController(
      text: widget.visitors.timeOut,
    );
    condoOwnerctrl = TextEditingController(
      text: widget.visitors.condoOwner,
    );
    condoNumberctrl = TextEditingController(
      text: widget.visitors.condoNumber,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Update Visitor's Information",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.amberAccent,
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
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/img-visitor.png'),
              fit: BoxFit.cover),
        ),
        child: ListView(
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: TextField(
                      controller: fullnamectrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Full Name',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: TextField(
                      controller: reasonVctrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Reason for Visit',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: TextField(
                      controller: timeInctrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Time-In',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: TextField(
                      controller: timeOutctrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'time-Out',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: TextField(
                      controller: condoOwnerctrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Condo Owner',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: TextField(
                      controller: condoNumberctrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Condo Number',
                      ),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          updateVisitor(widget.visitors.visit_id);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.black,
                        ),
                        child: const Text(
                          'UPDATE',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.amberAccent,
                          ),
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  updateVisitor(String visit_id) {
    final docVisitor =
        FirebaseFirestore.instance.collection('Visitor').doc(visit_id);
    final snackbar = SnackBar(
        duration: Duration(seconds: 2),
        margin: const EdgeInsets.only(bottom: 60),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        content: Row(children: [
          Expanded(
            child: Text(
              'Update Successfully!',
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

    docVisitor.update({
      'fullname': fullnamectrl.text,
      'reasonV': reasonVctrl.text,
      'timeIn': timeInctrl.text,
      'timeOut': timeOutctrl.text,
      'condoOwner': condoOwnerctrl.text,
      'condoNumber': condoNumberctrl.text,
    });

    Navigator.pop(context);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:visitors_log_project/src/constants/visitors.dart';

class Update extends StatefulWidget {
  const Update({
    super.key,
    required this.visitor,
  });

  final Visitors visitor;

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  late TextEditingController fullnamecontroller;
  late TextEditingController reasonVcontroller;
  late TextEditingController timeIncontroller;
  late TextEditingController timeOutcontroller;
  late TextEditingController condoOwnercontroller;
  late TextEditingController condoNumbercontroller;

  @override
  void initState() {
    super.initState();
    fullnamecontroller = TextEditingController(text: widget.visitor.fullname);
    reasonVcontroller = TextEditingController(text: widget.visitor.reasonV);
    timeIncontroller = TextEditingController(text: widget.visitor.timeIn);
    timeOutcontroller = TextEditingController(text: widget.visitor.timeOut);
    condoOwnercontroller =
        TextEditingController(text: widget.visitor.condoOwner);
    condoNumbercontroller =
        TextEditingController(text: widget.visitor.condoNumber);
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
        title: const Text('Update Enlisted Visitors'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextField(
                    controller: fullnamecontroller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Full Name',
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
                    controller: timeIncontroller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Time In',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextField(
                    controller: timeOutcontroller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Time Out',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextField(
                    controller: condoOwnercontroller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Condo Owner Visit',
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
                      updateVisitor(widget.visitor.id);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      'UPDATE',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  updateVisitor(String id) {
    final docVisitor = FirebaseFirestore.instance.collection('Visitor').doc(id);
    docVisitor.update({
      'fullname': fullnamecontroller.text,
      'reasonV': reasonVcontroller,
      'timeIn': timeIncontroller.text,
      'timeOut': timeOutcontroller.text,
      'condoOwner': condoOwnercontroller.text,
      'condoNumber': condoNumbercontroller.text,
    });

    Navigator.pop(context);
  }
}

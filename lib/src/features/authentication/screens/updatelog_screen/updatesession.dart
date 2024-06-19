import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:visitors_log_project/src/constants/docvisitor.dart';

class UpdateSession extends StatefulWidget {
  const UpdateSession({
    super.key,
    required this.visitorslog,
  });

  final VisitorsLog visitorslog;

  @override
  State<UpdateSession> createState() => _UpdateSessionState();
}

class _UpdateSessionState extends State<UpdateSession> {
  late TextEditingController idcontroller;

  @override
  void initState() {
    super.initState();
    idcontroller = TextEditingController(text: widget.visitorslog.id);
  }

  @override
  void dispose() {
    idcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Visitors Log Date'),
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
                    controller: idcontroller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter New Date',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      updateVisitor(widget.visitorslog.id);
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
    final docVisitor =
        FirebaseFirestore.instance.collection('Visitors').doc(id);
    docVisitor.update({
      'id': idcontroller.text,
    });

    Navigator.pop(context);
  }
}

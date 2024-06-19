import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitors_log_project/src/constants/docvisitor.dart';
import 'package:visitors_log_project/src/constants/visitors.dart';
import 'package:visitors_log_project/src/features/authentication/screens/trial_viewvisit/viewvisitor.dart';

import 'package:visitors_log_project/src/features/authentication/screens/trialupdate/update.dart';

import 'package:visitors_log_project/src/features/authentication/screens/viewlog_screen/add.dart';

class LogSession extends StatefulWidget {
  const LogSession({
    super.key,
    required this.visitorslog,
  });

  final VisitorsLog visitorslog;

  @override
  State<LogSession> createState() => _LogSession();
}

class _LogSession extends State<LogSession> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Visitors",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.amberAccent,
            )),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Add(id: widget.visitorslog.id),
                ),
              );
            },
            icon: const Icon(
              Icons.add_circle,
              color: Colors.amber,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/img-visitor.png'),
              fit: BoxFit.cover),
        ),
        padding: EdgeInsets.all(15),
        child: StreamBuilder<List<Visitors>>(
          stream: readVisitors(widget.visitorslog.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final visitors = snapshot.data!;

              return ListView(
                children: visitors.map(buildVisitor).toList(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  void gotoItemDetails(Visitors visitor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewVisit(
          visitor: visitor,
        ),
      ),
    );
  }

  Widget imgExist(img) => CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(img),
      );

  Widget imgNotExist() => const Icon(
        Icons.account_circle_rounded,
        size: 40,
      );

  Widget buildVisitor(Visitors visitor) => GestureDetector(
        onTap: () => gotoItemDetails(visitor),
        child: Card(
          elevation: 20,
          shadowColor: Colors.black,
          child: ListTile(
            hoverColor: Color.fromRGBO(192, 192, 192, 1),
            tileColor: Colors.white,
            leading: (visitor.image != "-")
                ? imgExist(visitor.image)
                : imgNotExist(),
            title: Text(
              visitor.fullname,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            subtitle: Text(visitor.condoOwner),
            dense: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Update(
                            visitors: visitor,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit)),
                IconButton(
                    onPressed: () {
                      _showActionSheet(context, visitor.visit_id);
                    },
                    icon: const Icon(Icons.delete)),
              ],
            ),
          ),
        ),
      );

  Stream<List<Visitors>> readVisitors(id) => FirebaseFirestore.instance
      .collection('Visitor')
      .where('id', isEqualTo: id)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Visitors.fromJson(
                doc.data(),
              ),
            )
            .toList(),
      );

  deleteVisitor(String visit_id) {
    final docVisitor =
        FirebaseFirestore.instance.collection('Visitor').doc(visit_id);
    docVisitor.delete();
    Navigator.pop(context);
  }

  void _showActionSheet(BuildContext context, String visit_id) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Confirmation'),
        message: const Text(
            'Are you sure you want to delete this user? Doing this will not undo any changes.'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              deleteVisitor(visit_id);
            },
            child: const Text('Continue'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

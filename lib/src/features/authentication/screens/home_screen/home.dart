import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:visitors_log_project/src/constants/docvisitor.dart';
import 'package:visitors_log_project/src/constants/users1.dart';
import 'package:visitors_log_project/src/features/authentication/screens/home_screen/addlog.dart';
import 'package:visitors_log_project/src/features/authentication/screens/search_screen/search.dart';

import 'package:visitors_log_project/src/features/authentication/screens/viewlog_screen/logsession.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  final urlCover = 'assets/images/condo.jpg';

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Dashboard Log",
          style: TextStyle(
            color: Colors.amberAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddLog(),
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
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    read(user.uid),
                  ],
                ),
              ],
            ),
            _buildItem(
              icon: Icons.search,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Search(),
                  ),
                );
              },
              title: 'Search All Visitors',
            ),
            _buildItem(
              icon: Icons.arrow_back,
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                _sucessLogOut();
              },
              title: 'Log Out',
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/condo.jpg'), fit: BoxFit.cover),
        ),
        padding: EdgeInsets.all(30),
        child: StreamBuilder<List<VisitorsLog>>(
          stream: readVisitorsLog(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final visitors = snapshot.data!;

              return ListView(
                children: visitors.map(buildLog).toList(),
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

  Widget buildLog(VisitorsLog visitorslog) => Card(
        elevation: 20,
        shadowColor: Colors.black,
        child: ListTile(
          hoverColor: Color.fromRGBO(192, 192, 192, 1),
          tileColor: Colors.white,
          //shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.circular(50),
          // side: BorderSide(width: 1, color: Colors.black)),
          leading: const Icon(
            Icons.calendar_month,
            size: 40,
            color: Colors.black,
          ),
          title: Text(
            visitorslog.id,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          dense: true,
          visualDensity: const VisualDensity(vertical: 4),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    _showActionSheet(context, visitorslog.id);
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 20,
                    color: Colors.black,
                  )),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LogSession(
                  visitorslog: visitorslog,
                ),
              ),
            );
          },
        ),
      );

  Stream<List<VisitorsLog>> readVisitorsLog() =>
      FirebaseFirestore.instance.collection('Visitors').snapshots().map(
            (snapshot) => snapshot.docs
                .map(
                  (doc) => VisitorsLog.fromJson(
                    doc.data(),
                  ),
                )
                .toList(),
          );

  deleteVisitor(String id) {
    final docVisitor =
        FirebaseFirestore.instance.collection('Visitors').doc(id);
    docVisitor.delete();
    Navigator.pop(context);
  }

  void _showActionSheet(BuildContext context, String id) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Confirmation'),
        message: const Text(
            'Are you sure you want to delete this user? Doing this will not undo any changes.'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              deleteVisitor(id);
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

  _buildItem(
      {required IconData icon,
      required String title,
      required GestureTapCallback onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        size: 25,
        color: Colors.amberAccent,
      ),
      minLeadingWidth: 5,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.amberAccent,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
      onTap: onTap,
    );
  }

  _sucessLogOut() {
    final snackbar = SnackBar(
        duration: Duration(seconds: 2),
        margin: const EdgeInsets.only(bottom: 60),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        content: Row(children: [
          Expanded(
            child: Text(
              'Log Out Success!',
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(width: 5),
          Icon(
            Icons.error,
            color: Colors.black,
          ),
        ]));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}

Widget ImgExist(img) => CircleAvatar(
      radius: 90,
      backgroundImage: NetworkImage(img),
    );

Widget imgNotExist() => const Icon(
      Icons.account_circle_rounded,
      size: 40,
    );

Widget buildUser(Users1 user) => Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(50),
              child: CircleAvatar(
                backgroundColor: Colors.amberAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImgExist(user.image),
                  ],
                ),
                radius: 95,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            user.name,
            style: TextStyle(
              color: Colors.amberAccent,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Icon(
                Icons.email,
                color: Colors.amberAccent,
                size: 20,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                user.email,
                style: TextStyle(
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ],
    );

Widget read(uid) {
  var collection = FirebaseFirestore.instance.collection('Users');
  return Column(
    children: [
      SizedBox(
        height: 399,
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: collection.doc(uid).snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasError) return Text('Error = ${snapshot.error}');

            if (snapshot.hasData) {
              final users = snapshot.data!.data();
              final newUser = Users1(
                id: users!['id'],
                name: users['name'],
                password: users['password'],
                email: users['email'],
                image: users['image'],
              );

              return buildUser(newUser);
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    ],
  );
}

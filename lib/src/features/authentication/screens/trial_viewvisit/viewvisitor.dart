import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:visitors_log_project/src/constants/visitors.dart';

class ViewVisit extends StatelessWidget {
  const ViewVisit({
    super.key,
    required this.visitor,
  });

  final Visitors visitor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Visitor's Information",
          style: TextStyle(
            color: Colors.amberAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  itemdetails(context, visitor),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget itemdetails(BuildContext context, Visitors newvisitor) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/img-visitor.png'),
              fit: BoxFit.cover),
        ),
        height: 700,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Card(
          elevation: 20,
          shadowColor: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImgExist(visitor.image),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Visitor's Date: "),
                  Text(
                    newvisitor.id,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Visitor's Name: "),
                  Text(
                    newvisitor.fullname,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Reason for Visit: "),
                  Text(
                    newvisitor.reasonV,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Condo Owner: "),
                  Text(
                    newvisitor.condoOwner,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Condo Room Number: "),
                  Text(
                    newvisitor.condoNumber,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Time In: "),
                  Text(
                    newvisitor.timeIn,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Time Out: "),
                  Text(
                    newvisitor.timeOut,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget ImgExist(img) => CircleAvatar(
        radius: 90,
        backgroundImage: NetworkImage(img),
      );

  Widget imgNotExist() => const Icon(
        Icons.account_circle_rounded,
        size: 40,
      );

  Widget buildUser(Visitors visitors) => Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.all(50),
                child: CircleAvatar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ImgExist(visitors.image),
                    ],
                  ),
                  radius: 90,
                ),
              ),
            ],
          ),
        ],
      );

  Widget read(id) {
    var collection = FirebaseFirestore.instance.collection('Visitor');
    return Column(
      children: [
        SizedBox(
          height: 399,
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: collection.doc(id).snapshots(),
            builder: (_, snapshot) {
              if (snapshot.hasError) return Text('Error = ${snapshot.error}');

              if (snapshot.hasData) {
                final visitors = snapshot.data!.data();
                final newVisitor = Visitors(
                  id: visitors!['id'],
                  fullname: visitors['fullname'],
                  timeIn: visitors['timeIn'],
                  reasonV: visitors['reasonV'],
                  image: visitors['image'],
                  timeOut: visitors['timeOut'],
                  condoNumber: visitors['condoNumber'],
                  condoOwner: visitors['condoOwner'],
                  visit_id: visitors['visit_id'],
                );

                return buildUser(newVisitor);
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}

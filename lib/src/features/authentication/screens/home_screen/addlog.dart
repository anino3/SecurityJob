import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visitors_log_project/src/constants/docvisitor.dart';

class AddLog extends StatefulWidget {
  const AddLog({super.key});

  @override
  State<AddLog> createState() => _AddLogState();
}

class _AddLogState extends State<AddLog> {
  late TextEditingController datecontroller;
  DateTime datetime = DateTime.now();

  @override
  void initState() {
    super.initState();
    datecontroller = TextEditingController();
  }

  @override
  void dispose() {
    datecontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/condo.jpg',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Color.fromARGB(0, 255, 247, 247).withOpacity(0.7),
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text("Visitors Log",
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
                        onTap: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) => CupertinoActionSheet(
                              actions: [builddatepicker()],
                              cancelButton: CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Done'),
                              ),
                            ),
                          );
                        },
                        readOnly: true,
                        controller: datecontroller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Date',
                        ),
                      ),

                      /*child: TextField(
                        controller: datecontroller,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.black,
                            ),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Enter the date today (mm/dd/yyyy)',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),*/
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          if (datecontroller.text == "") {
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
                            createVisitorLog();
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
                            color: Colors.amberAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget builddatepicker() => SizedBox(
        height: 180,
        child: CupertinoDatePicker(
          minimumYear: 1900,
          maximumYear: DateTime.now().year,
          initialDateTime: datetime,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (datetime) {
            setState(() {
              this.datetime = datetime;
              final value = DateFormat('MM-dd-yyyy').format(datetime);
              datecontroller.text = value;
            });
          },
        ),
      );

  Future createVisitorLog() async {
    final docVisitor = FirebaseFirestore.instance
        .collection('Visitors')
        .doc(datecontroller.text);

    final newVisitor = VisitorsLog(
      id: docVisitor.id,
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
              'Visitor Log Created',
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
      datecontroller.text = "";
    });
  }
}

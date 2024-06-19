import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:visitors_log_project/src/features/authentication/screens/search_screen/conversation_list.dart';

class Visitor extends StatefulWidget {
  final String id;
  final String fullname;
  final String reasonV;
  final String timeIn;
  final String timeOut;
  final String condoOwner;
  final String condoNumber;
  final String visit_id;
  final String image;
  Visitor({
    super.key,
    required this.id,
    required this.fullname,
    required this.reasonV,
    required this.timeIn,
    required this.timeOut,
    required this.condoOwner,
    required this.condoNumber,
    required this.visit_id,
    required this.image,
  });
  @override
  // ignore: library_private_types_in_public_api
  _VisitorState createState() => _VisitorState();
}

class _VisitorState extends State<Visitor> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController searchcontroller;
  String filter = "";
  @override
  void initState() {
    searchcontroller = TextEditingController();
    super.initState();
  }

  final Stream<QuerySnapshot> userQuery =
      FirebaseFirestore.instance.collection('Visitor').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chats',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      // backgroundColor: Colors.grey[300],
      body: RefreshIndicator(
        onRefresh: () async {
          // Perform refresh operation
          setState(() {
            // userQuery =
            //     FirebaseFirestore.instance.collection('users').snapshots();
          });
        },
        child: Expanded(
          child: ListView(
            // List of items
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              filter = value;
                            });
                          },
                          controller: searchcontroller,
                          decoration: InputDecoration(
                            hintText: "Search...",
                            hintStyle: TextStyle(color: Colors.grey.shade600),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey.shade600,
                              size: 20,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.all(8),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade100)),
                          ),
                        ),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: userQuery,
                        builder: ((BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final datas = snapshot.requireData;
                          return Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: datas.size,
                              itemBuilder: (context, index) {
                                var data = snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                                if (filter.isEmpty) {
                                  return Visitor(
                                    image: datas.docs[index]['image'],
                                    fullname: datas.docs[index]['fullname'],
                                    id: datas.docs[index]['id'],
                                    reasonV: datas.docs[index]['reasonV'],
                                    timeIn: datas.docs[index]['timeIn'],
                                    timeOut: datas.docs[index]['timeOut'],
                                    condoNumber: datas.docs[index]
                                        ['condoNumber'],
                                    condoOwner: datas.docs[index]['condoOwner'],
                                    visit_id: datas.docs[index]['visit_id'],
                                  );
                                }
                                if (data['name']
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(filter.toLowerCase())) {
                                  return ConversationList(
                                    image: data['image'],
                                    fullname: data['fullname'],
                                    id: data['id'],
                                    reasonV: data['reasonV'],
                                    timeIn: data['timeIn'],
                                    timeOut: data['timeOut'],
                                    condoNumber: data['condoNumber'],
                                    condoOwner: data['condoOwner'],
                                    visit_id: data['visit_id'],
                                  );
                                }
                                return Container();
                              },
                            ),
                          );
                        })),
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

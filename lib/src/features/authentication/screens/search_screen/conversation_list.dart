import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConversationList extends StatefulWidget {
  final String id;
  final String fullname;
  final String reasonV;
  final String timeIn;
  final String timeOut;
  final String condoOwner;
  final String condoNumber;
  final String visit_id;
  final String image;
  ConversationList({
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
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}

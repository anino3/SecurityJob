import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:visitors_log_project/src/features/authentication/screens/home_screen/addlog.dart';
import 'package:visitors_log_project/src/features/authentication/screens/home_screen/home.dart';
import 'package:visitors_log_project/src/features/authentication/screens/search_screen/search.dart';

class Home1 extends StatefulWidget {
  const Home1({super.key});

  @override
  State<Home1> createState() => _Home1State();
}

class _Home1State extends State<Home1> {
  @override
  void initState() {
    super.initState();
  }

  int currentIndex = 0;

  final screens = [
    Home(),
    Search(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.amberAccent,
          unselectedItemColor: Colors.amberAccent,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() => currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.security),
              label: "Security Job",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Search",
            ),
          ],
        ),
      );
}

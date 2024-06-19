import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:visitors_log_project/src/constants/image_strings.dart';
import 'package:visitors_log_project/src/constants/sizes.dart';
import 'package:visitors_log_project/src/constants/text_strings.dart';
import 'package:visitors_log_project/src/features/authentication/screens/home_screen/home.dart';
import 'package:visitors_log_project/src/features/authentication/screens/login_screen/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late TextEditingController usernamecontroller;
  late TextEditingController passwordcontroller;
  late String error;
  bool animate = false;

  @override
  void initState() {
    startAnimation();
    usernamecontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    error = "";
    super.initState();
  }

  @override
  void dispose() {
    usernamecontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1600),
            top: animate ? 0 : -200,
            left: animate ? 0 : -200,
            child: SizedBox(
              height: 300,
              child: Container(
                padding: EdgeInsets.only(bottom: 100),
                child: Image(
                  image: AssetImage(tSplashTopIcon),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1600),
            top: 150,
            bottom: 100,
            left: animate ? tDefaultSize : -80,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 1600),
              opacity: animate ? 1 : 0,
              child: Column(
                children: [
                  Text(
                    tAppName,
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    tAppTagLine,
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 45,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 2600),
            bottom: animate ? 30 : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 2000),
              opacity: animate ? 1 : 0,
              child: SizedBox(
                height: 500,
                width: 400,
                child: Image(
                  image: AssetImage(tSplashTopImage),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future startAnimation() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() => animate = true);
    await Future.delayed(Duration(milliseconds: 3000));
    Navigator.of(context)
        .pushReplacement(CupertinoPageRoute(builder: (ctx) => Login()));
  }
}

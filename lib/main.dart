import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import 'package:visitors_log_project/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:visitors_log_project/src/constants/image_strings.dart';
import 'package:visitors_log_project/src/constants/sizes.dart';
import 'package:visitors_log_project/src/constants/text_strings.dart';
import 'package:visitors_log_project/src/features/authentication/screens/home_screen/home1.dart';
import 'package:visitors_log_project/src/features/authentication/screens/login_screen/login.dart';

import 'src/features/authentication/screens/home_screen/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation',
      home: SplashScreen(),
    );
  }
}

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
      backgroundColor: Colors.white,
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
            left: animate ? tDefaultSize : -20,
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
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    tAppTagLine,
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
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
        .pushReplacement(CupertinoPageRoute(builder: (ctx) => MyHomePage()));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong!'),
              );
            } else if (snapshot.hasData) {
              return const Home();
            } else {
              return const Login();
            }
          },
        ),
      );
}

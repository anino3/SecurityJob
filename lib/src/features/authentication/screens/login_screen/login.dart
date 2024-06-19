import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:visitors_log_project/src/features/authentication/screens/register_screen/registertrial.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController usernamecontroller;
  late TextEditingController passwordcontroller;
  late String error;

  @override
  void initState() {
    super.initState();
    usernamecontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    error = "";
  }

  @override
  void dispose() {
    usernamecontroller.dispose();
    passwordcontroller.dispose();
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
          body: ListView(
            children: [
              Container(
                padding: EdgeInsets.only(top: 50),
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/security_thumbnail.png',
                      fit: BoxFit.cover,
                      width: 200,
                      height: 300,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Login Your Account',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                        style: TextStyle(color: Colors.deepOrange),
                        controller: usernamecontroller,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.deepOrange,
                            ),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Enter email',
                          labelStyle: TextStyle(
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: TextField(
                        style: TextStyle(color: Colors.deepOrange),
                        obscureText: true,
                        controller: passwordcontroller,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.deepOrange,
                            ),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Enter password',
                          labelStyle: TextStyle(
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.lock_open,
                        ),
                        onPressed: () {
                          if (passwordcontroller.text == "" ||
                              usernamecontroller.text == "") {
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
                            signIn();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.deepOrange,
                        ),
                        label: const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterTrial(),
                              ),
                            );
                          },
                          child: Text(
                            'Create an Account',
                            style: TextStyle(color: Colors.deepOrange),
                          )),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        error,
                        style: TextStyle(
                          color: Colors.red,
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

  Future signIn() async {
    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernamecontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );
      final snackbar = SnackBar(
          duration: Duration(seconds: 2),
          margin: const EdgeInsets.only(bottom: 60),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          content: Row(children: [
            Expanded(
              child: Text(
                'Login Successfully!',
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
        error = "";
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        error = e.message.toString();
      });
    }
    Navigator.pop(context);
  }
}

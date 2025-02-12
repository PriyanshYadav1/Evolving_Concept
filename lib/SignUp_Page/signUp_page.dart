import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:threadswap/Login_Page/login_screen.dart';
import 'package:threadswap/Services/emailAuthService_recovery.dart';

class SignUpForm extends StatefulWidget {
  SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  TextEditingController? Email;
  TextEditingController? Passsword;
  TextEditingController? Confirm_Passsword;
  TextEditingController? Name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Email = TextEditingController();
    Passsword = TextEditingController();
    Confirm_Passsword = TextEditingController();
    Name = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    Email?.dispose();
    Passsword?.dispose();
    Confirm_Passsword?.dispose();
    Name?.dispose();
    super.dispose();
  }

  // Ever wondered how to retrieve name from firebase heres how :-
  // String userName = userCredential.user?.displayName ?? "No name provided";
  // print("User name: $userName");

  void _signUpUser(BuildContext context, String email, String password, String name) async {
    try {
      AuthService authService = AuthService();
      UserCredential userCredential =
          await authService.signUp(email, password, name);
      // Handle successful sign-up
      Fluttertoast.showToast(
          msg: "Signed up successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
      print("Signed up successfully: ${userCredential.user?.email}, Name: ${userCredential.user?.displayName}");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login_Screen() ));
    } catch (e) {
      // Handle error (e.g., show a dialog or message to the user)
      print("Sign up failed: $e");
      Fluttertoast.showToast(
          msg: "Sign up failed: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }


  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Login Failure"),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/images/background.jpg",
              fit: BoxFit.cover,
            ),
            Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Image(
                            image: const AssetImage("assets/images/signup.png"),
                            height: MediaQuery.of(context).size.height * 0.3),
                      ),
                      Text(
                        'Create an account.',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: Name,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.person_outline_outlined),
                                  hintText: 'Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        30.0), // Set the border radius here
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    // Set the same radius for enabled border
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    // Set the same radius for focused border
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: Email,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.alternate_email_outlined),
                                  hintText: 'Email',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        30.0), // Set the border radius here
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    // Set the same radius for enabled border
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    // Set the same radius for focused border
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: Passsword,
                                obscureText: _obscureText1,
                                // Hide the text if true
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.fingerprint),
                                  hintText: 'Password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        30.0), // Set the border radius for rounded corners
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    // Same radius for enabled state
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    // Same radius for focused state
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Change icon based on visibility of password
                                      _obscureText1
                                          ? Icons.remove_red_eye_sharp
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      // Toggle the obscureText state to show or hide password
                                      setState(() {
                                        _obscureText1 = !_obscureText1;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: Confirm_Passsword,
                                obscureText: _obscureText2,
                                // Hide the text if true
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.fingerprint),
                                  hintText: 'Confirm Password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        30.0), // Set the border radius for rounded corners
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    // Same radius for enabled state
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    // Same radius for focused state
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Change icon based on visibility of password
                                      _obscureText2
                                          ? Icons.remove_red_eye_sharp
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      // Toggle the obscureText state to show or hide password
                                      setState(() {
                                        _obscureText2 = !_obscureText2;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 45,
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: OutlinedButton(
                                  onPressed: () {
                                    if (Name?.text != null &&
                                        Passsword?.text != null &&
                                        Confirm_Passsword?.text != null &&
                                        Email?.text != null) {
                                      if (Passsword?.text ==
                                          Confirm_Passsword?.text)
                                          _signUpUser(context, Email!.text, Passsword!.text, Name!.text);
                                      else {
                                        var snackBar = SnackBar(
                                          content:
                                              Text('Passwords do not match.'),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    }
                                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard_Screen() ));
                                  },
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: BorderSide(
                                        color: Colors.grey,
                                        width:
                                            1), // Set the outline color to grey
                                  ),
                                ),
                              ),
                              // SizedBox(height: 45),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Login_Screen(),
                                          ));
                                    },
                                    child: const Text(
                                      'Go back to Login',
                                      style: TextStyle(color: Colors.blue),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

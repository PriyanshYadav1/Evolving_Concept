import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  bool _isLoading = false;

  TextEditingController? Email;
  TextEditingController? Passsword;
  TextEditingController? Confirm_Passsword;
  TextEditingController? Name;

  String _passwordStrengthMessage = "Enter a password to check its strength.";

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

  void _signUpUser(
      BuildContext context, String email, String password, String name) async {
    setState(() {
      _isLoading = true; // Start loading when the sign-up is triggered
    });

    try {
      AuthService authService = AuthService();
      UserCredential userCredential =
          await authService.signUp(email, password, name, context);
      _postToast("Logged in successfully!");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login_Screen()));
    } catch (e) {
      _postToast("Sign up failed: $e");
    } finally {
      setState(() {
        _isLoading = false; // Stop loading when the sign-up process ends
      });
    }
  }

  void _postToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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

  // Function to check password strength
  bool isPasswordStrong(String password) {
    // Check for minimum length of 8 characters
    if (password.length < 8) {
      return false;
    }

    // Check if it contains at least one uppercase letter
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));

    // Check if it contains at least one uppercase letter
    bool hasNumber = password.contains(RegExp(r'[0-9]'));

    // Check if it contains at least one special character
    bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    // Return true if both conditions are satisfied
    return hasUppercase && hasSpecialChar && hasNumber;
  }

  // Function to update the password strength message
  void updatePasswordStrength(String password) {
    setState(() {
      if (isPasswordStrong(password)) {
        _passwordStrengthMessage = "Password is strong!";
      } else {
        _passwordStrengthMessage =
            "Password is weak. Ensure it's at least 8 characters, contains an uppercase letter, and a special character.";
      }
    });
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
                                onChanged: (value) {
                                  updatePasswordStrength(value);
                                  ;
                                },
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _passwordStrengthMessage,
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.red),
                                ),
                              ),
                              const SizedBox(height: 5),
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
                                    if (Name?.text.isNotEmpty == true &&
                                        Passsword?.text.isNotEmpty == true &&
                                        Confirm_Passsword?.text.isNotEmpty ==
                                            true &&
                                        Email?.text.isNotEmpty == true) {
                                      if (Passsword?.text ==
                                          Confirm_Passsword?.text) {
                                        if (RegExp(
                                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                            .hasMatch(Email!.text)) {
                                          _signUpUser(context, Email!.text,
                                              Passsword!.text, Name!.text);
                                        } else {
                                          _postToast(
                                              'Please enter a valid email address.');
                                        }
                                      } else {
                                        _postToast('Passwords do not match.');
                                      }
                                    } else {
                                      _postToast('All fields are required.');
                                    }
                                  },
                                  child: _isLoading
                                      ? LinearProgressIndicator(
                                          color: Colors.black,
                                        )
                                      : Text(
                                          "Sign up",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: BorderSide(
                                        color: Colors.grey, width: 1),
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

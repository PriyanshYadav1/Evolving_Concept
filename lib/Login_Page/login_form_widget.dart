import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:threadswap/Dashboard/dashboard_Screen.dart';
import 'package:threadswap/Recovery_Page/Recovery_Page.dart';
import 'package:threadswap/Services/emailAuthService_recovery.dart';

class LoginForm extends StatefulWidget {
  LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscureText = false;

  bool _isLoading = true;
  TextEditingController? Email;
  TextEditingController? Passsword;

  // void _login() async {
  //   setState(() {
  //     _isLoading = true; // Show the progress indicator
  //   });
  //
  //
  //   // Check if Email and Password are not null and not empty
  //   if (Email != null &&
  //       Passsword != null &&
  //       Email!.text.isNotEmpty &&
  //       Passsword!.text.isNotEmpty) {
  //     try {
  //       await AuthService().login(Email!.text, Passsword!.text);
  //
  //       // Navigate to home screen if login is successful
  //       Navigator.pushReplacement(context,
  //           MaterialPageRoute(builder: (context) => Dashboard_Screen()));
  //
  //       setState(() {
  //         _isLoading = false; // Hide the progress indicator
  //       });
  //     } catch (e) {
  //       setState(() {
  //         _isLoading = false; // Hide the progress indicator
  //       });
  //       // Show a dialog with the error message when login fails
  //       _showErrorDialog(e.toString());
  //     }
  //   } else {
  //     setState(() {
  //       _isLoading = false; // Hide the progress indicator
  //     });
  //     _showErrorDialog("Fields cannot be empty");
  //   }
  // }

  void _login() async {
    setState(() {
      _isLoading = true; // Show the progress indicator
    });

    // Check if Email and Password are not null and not empty
    if (Email != null &&
        Passsword != null &&
        Email!.text.isNotEmpty &&
        Passsword!.text.isNotEmpty) {
      try {
        // Attempt to login using AuthService
        UserCredential userCredential =
            await AuthService().login(Email!.text, Passsword!.text);

        // Get the logged-in user from userCredential
        User? user = userCredential.user;

        // Check if the user's email is verified
        if (user != null && user.emailVerified) {
          // Navigate to home screen if email is verified
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard_Screen()),
          );
        } else {
          // Email is not verified, show dialog and send a verification email
          await user?.sendEmailVerification();
          _showErrorDialog(
            "Your email is not verified. Please check your inbox and verify your email before logging in.",
          );
        }

        setState(() {
          _isLoading = false; // Hide the progress indicator
        });
      } catch (e) {
        setState(() {
          _isLoading = false; // Hide the progress indicator
        });
        // Show a dialog with the error message when login fails
        _showErrorDialog(e.toString());
      }
    } else {
      setState(() {
        _isLoading = false; // Hide the progress indicator
      });
      _showErrorDialog("Fields cannot be empty");
    }
  }

  void _showVerificationDialog(User? user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Email Not Verified"),
        content: Text(
            "Please verify your email address before logging in. Do you want to resend the verification email?"),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              // Resend the verification email
              try {
                await user?.sendEmailVerification();
                Navigator.of(ctx).pop();
                _showInfoDialog(
                    "A new verification email has been sent to your email address.");
              } catch (e) {
                Navigator.of(ctx).pop();
                _showErrorDialog("Failed to send verification email: $e");
              }
            },
            child: Text("Resend Email"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Email = TextEditingController();
    Passsword = TextEditingController();
  }

  @override
  void dispose() {
    Email?.dispose();
    Passsword?.dispose();
    super.dispose();
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
          )
        ],
      ),
    );
  }

  void _showInfoDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Info"),
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
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: Email,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(30.0), // Set the border radius here
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  // Set the same radius for enabled border
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  // Set the same radius for focused border
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: Passsword,
              obscureText: _obscureText, // Hide the text if true
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
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  // Same radius for focused state
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  icon: Icon(
                    // Change icon based on visibility of password
                    _obscureText
                        ? Icons.remove_red_eye_sharp
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    // Toggle the obscureText state to show or hide password
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Recovery_Page(),
                        ));
                  },
                  child: const Text(
                    'Forget Password?',
                    style: TextStyle(color: Colors.blue),
                  )),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  _login();
                },
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.black),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                      color: Colors.grey,
                      width: 1), // Set the outline color to grey
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

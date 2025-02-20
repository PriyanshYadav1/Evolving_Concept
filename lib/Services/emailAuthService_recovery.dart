import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login function
  Future<UserCredential> login(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Logged in: ${userCredential.user?.email}");
      return userCredential;
    } catch (e) {
      // Rethrow the error so that it can be handled by the UI
      throw Exception("Invalid credentials. Please try again.");
    }
  }



  // SignUp function
  Future<UserCredential> signUp(
      String email, String password, String name , BuildContext context) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update the user's profile with their name
      await userCredential.user?.updateProfile(displayName: name);
      await userCredential.user?.sendEmailVerification();

      print(
          "Signed up: ${userCredential.user?.email}, Name: ${userCredential.user?.displayName}");
      return userCredential;
    } catch (e) {
      throw Exception("SignUp failed: $e");
    }
  }

  // Future<UserCredential> signUp(
  //     String email, String password, String name, BuildContext context) async {
  //   try {
  //     // First, create the user with email and password
  //     final UserCredential userCredential =
  //     await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //
  //     // Update the user's profile with their name
  //     await userCredential.user?.updateProfile(displayName: name);
  //
  //     // Send the email verification
  //     await userCredential.user?.sendEmailVerification();
  //
  //     print(
  //         "Signed up: ${userCredential.user?.email}, Name: ${userCredential.user?.displayName}");
  //
  //     // Inform the user that they need to verify their email
  //     _showInfoDialog("A verification email has been sent. Please verify your email before logging in.", context);
  //
  //     return userCredential;
  //   } catch (e) {
  //     throw Exception("SignUp failed: $e");
  //   }
  // }

  void _showInfoDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Info"),
        content: Text(message),
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

  // Password recovery function
  Future<void> recoverPassword(String email) async {
    if (email.isEmpty) {
      throw Exception("Please enter a valid email address.");
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent. Check your inbox!");
    } catch (e) {
      throw Exception("Password recovery failed: $e");
    }
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
//
// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // Login function
//   Future<UserCredential> login(String email, String password) async {
//     try {
//       final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       print("Logged in: ${userCredential.user?.email}");
//       return userCredential;
//     } catch (e) {
//       throw Exception("Login failed: $e");
//     }
//   }
//
//   // SignUp function
//   Future<UserCredential> signUp(String email, String password) async {
//     try {
//       final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       print("Signed up: ${userCredential.user?.email}");
//       return userCredential;
//     } catch (e) {
//       throw Exception("SignUp failed: $e");
//     }
//   }
//
//   // Password recovery function
//   Future<void> recoverPassword(String email) async {
//     if (email.isEmpty) {
//       throw Exception("Please enter a valid email address.");
//     }
//
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//       print("Password reset email sent. Check your inbox!");
//     } catch (e) {
//       throw Exception("Password recovery failed: $e");
//     }
//   }
// }

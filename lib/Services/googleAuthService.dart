import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign-in function for Google
  Future<Map<String, dynamic>> signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return {
          'status': 'error',
          'message': 'User canceled the sign-in process.'
        }; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        final User? user = userCredential.user;
        return {
          'status': 'success',
          'message': 'Successfully signed in.',
          'user': user,
          'email': user?.email,
          'name': user?.displayName,
        };
      } else {
        return {
          'status': 'error',
          'message': 'Failed to sign in with Google.',
        };
      }
    } catch (e) {
      print("Error during Google sign-in: $e");
      return {
        'status': 'error',
        'message': 'An error occurred during sign-in.',
      };
    }
  }

  // Sign-out function
  Future<Map<String, String>> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      return {'status': 'success', 'message': 'Successfully signed out.'};
    } catch (e) {
      return {'status': 'error', 'message': 'An error occurred during sign-out.'};
    }
  }

  // Method to verify if the user is already logged in
  Future<Map<String, dynamic>> checkLoginStatus() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return {
        'status': 'success',
        'message': 'User is already logged in.',
        'user': user,
        'email': user.email,
        'name': user.displayName,
      };
    } else {
      return {
        'status': 'error',
        'message': 'No user is not logged in.',
      };
    }
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// class GoogleAuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//
//   // Sign-in function for Google
//   Future<User?> signIn() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         return null; // The user canceled the sign-in
//       }
//
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       final OAuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       final UserCredential userCredential = await _auth.signInWithCredential(credential);
//       return userCredential.user;
//     } catch (e) {
//       print("Error during Google sign-in: $e");
//       return null;
//     }
//   }
//
//   // Sign-out function
//   Future<void> signOut() async {
//     await _auth.signOut();
//     await _googleSignIn.signOut();
//   }
// }
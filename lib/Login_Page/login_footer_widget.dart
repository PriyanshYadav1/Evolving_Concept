import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threadswap/Dashboard/dashboard_Screen.dart';
import 'package:threadswap/Services/googleAuthService.dart';
import 'package:threadswap/SignUp_Page/signUp_page.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 5),
          const Text("OR"),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              icon: const Image(
                  image: AssetImage("assets/images/google.png"), width: 20.0),

              //SIGN IN WITH GOOGLE
              onPressed: () async {
                GoogleAuthService auth = new GoogleAuthService();
                // Sign-in
                final signInResult = await auth.signIn();
                if (signInResult['status'] == 'success') {

                  var snackBar = SnackBar(
                    content: Text('Logged in successfully'),
                  );

                  // Find the ScaffoldMessenger in the widget tree
                  // and use it to show a SnackBar.
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  //Using shared Preferences to save user
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString("username",signInResult['name']);
                  await prefs.setString("useremail",signInResult['email']);

                  print("Sign-in successful:");
                  print("Name: ${signInResult['name']}");
                  print("Email: ${signInResult['email']}");

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard_Screen() ));
                } else {
                  print("Message: ${signInResult['message']}");
                }
              },
              label: const Text(
                'Sign in with Google',
                style: TextStyle(color: Colors.black),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey, width: 1),)// Set the outline color to grey)
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpForm() ));
            },
            child: Text.rich(
              TextSpan(
                  text: "Don't have an account ?   ",
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: const [
                    TextSpan(
                        text: 'Sign Up', style: TextStyle(color: Colors.blue))
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

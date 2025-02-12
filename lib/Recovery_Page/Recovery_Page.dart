import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:threadswap/Login_Page/login_screen.dart';
import 'package:threadswap/Services/emailAuthService_recovery.dart';

class Recovery_Page extends StatefulWidget {
  Recovery_Page({
    Key? key,
  }) : super(key: key);

  @override
  State<Recovery_Page> createState() => _Recovery_PageState();
}

class _Recovery_PageState extends State<Recovery_Page> {
  bool _obscureText = true;

  // Initialize the TextEditingController properly
  TextEditingController? Email;

  @override
  void initState() {
    super.initState();
    // Initialize the TextEditingController
    Email = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    Email?.dispose();
    super.dispose();
  }

  void _recoverPassword(String email) async {
    try {
      AuthService authService = AuthService();
      await authService.recoverPassword(email);
      // Show success message or prompt user to check their email
      _showErrorDialog("Password reset email sent.");
    } catch (e) {
      // Handle error (e.g., show a dialog or message to the user)
      _showErrorDialog("Password recovery failed: $e");
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Email Status"),
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
                            image: const AssetImage("assets/images/recovery.png"),
                            height: MediaQuery.of(context).size.height * 0.3),
                      ),
                      Text(
                        'Lost your account?',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      SizedBox(height: 5),
                      Text("To receive a recovery email, please provide your email address. If you encounter any issues or need further assistance, feel free to contact us at yadavpriyansh200@gmail.com. We're here to help!",
                          style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(
                        height: 50,
                      ),
                      Form(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: Email,  // Now properly initialized
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.alternate_email_outlined),
                                  hintText: 'Email',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(color: Colors.grey, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(color: Colors.blue, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
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
                                    // Ensure Email is not null and handle the recovery
                                    _recoverPassword(Email!.text);
                                  },
                                  child: Text(
                                    "Send",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: BorderSide(color: Colors.grey, width: 1),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login_Screen(),));
                                    },
                                    child: const Text(
                                      'Go back to Login',
                                      style: TextStyle(color: Colors.blue),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
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






// class _Recovery_PageState extends State<Recovery_Page> {
//   bool _obscureText = true;
//
//   TextEditingController? Email;
//
//   void _recoverPassword(String email) async {
//     try {
//       AuthService authService = AuthService();
//       await authService.recoverPassword(email);
//       // Show success message or prompt user to check their email
//       _showErrorDialog("Password reset email sent.");
//     } catch (e) {
//       // Handle error (e.g., show a dialog or message to the user)
//       _showErrorDialog("Password recovery failed: $e");
//     }
//   }
//
//   void _showErrorDialog(String errorMessage) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text("Login Failure"),
//         content: Text(errorMessage),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//             child: Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Stack(
//           fit: StackFit.expand,
//           children: [
//             Image.asset(
//               "assets/images/background.jpg",
//               fit: BoxFit.cover,
//             ),
//             Center(
//               child: SingleChildScrollView(
//                 physics: BouncingScrollPhysics(),
//                 child: Container(
//                   padding: const EdgeInsets.all(30),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Center(
//                         child: Image(
//                             image: const AssetImage("assets/images/recovery.png"),
//                             height: MediaQuery.of(context).size.height * 0.3),
//                       ),
//                       Text(
//                         'Lost your account?',
//                         style: TextStyle(
//                             fontSize: 30,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black),
//                       ),
//                       SizedBox(height: 5,),
//                       Text("To receive a recovery email, please provide your email address. If you encounter any issues or need further assistance, feel free to contact us at yadavpriyansh200@gmail.com \n \nWere here to help!", style: Theme.of(context).textTheme.bodyMedium),
//                       SizedBox(
//                         height: 50,
//                       ),
//                       Form(
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               TextFormField(
//                                 controller: Email,
//                                 decoration: InputDecoration(
//                                   prefixIcon: Icon(Icons.alternate_email_outlined),
//                                   hintText: 'Email',
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                     BorderRadius.circular(30.0), // Set the border radius here
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(30.0),
//                                     // Set the same radius for enabled border
//                                     borderSide: BorderSide(color: Colors.grey, width: 1),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(30.0),
//                                     // Set the same radius for focused border
//                                     borderSide: BorderSide(color: Colors.blue, width: 2),
//                                   ),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 45,
//                               ),
//                               SizedBox(
//                                 width: double.infinity,
//                                 height: 50,
//                                 child: OutlinedButton(
//                                   onPressed: () {
//                                     // var snackBar = SnackBar(
//                                     //   content:
//                                     //       Text('This feature is not available'),
//                                     // );
//                                     // ScaffoldMessenger.of(context)
//                                     //     .showSnackBar(snackBar);
//                                     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard_Screen() ));
//
//                                       _recoverPassword(Email!.text);
//                                   },
//                                   child: Text(
//                                     "Send",
//                                     style: TextStyle(color: Colors.black),
//                                   ),
//                                   style: OutlinedButton.styleFrom(
//                                     backgroundColor: Colors.white,
//                                     side: BorderSide(
//                                         color: Colors.grey,
//                                         width:
//                                             1), // Set the outline color to grey
//                                   ),
//                                 ),
//                               ),
//                               // SizedBox(height: 45),
//                               Align(
//                                 alignment: Alignment.centerRight,
//                                 child: TextButton(
//                                     onPressed: () {
//                                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login_Screen(),));
//                                     },
//                                     child: const Text(
//                                       'Go back to Login',
//                                       style: TextStyle(color: Colors.blue),
//                                     )),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

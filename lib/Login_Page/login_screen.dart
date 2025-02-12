import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:threadswap/Login_Page/login_footer_widget.dart';
import 'package:threadswap/Login_Page/login_form_widget.dart';
import 'package:threadswap/Login_Page/login_header_widget.dart';

class Login_Screen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset("assets/images/background.jpg",fit: BoxFit.cover,),
            Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LoginHeaderWidget(),  // Custom header widget
                      SizedBox(height: 0),  // Adds some space between header and form
                      LoginForm(),  // Custom form widget
                      SizedBox(height: 0),  // Adds some space between form and footer
                      LoginFooterWidget(),  // Custom footer widget
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image(
                image: const AssetImage("assets/images/welcome.png"),
                height: size.height * 0.26),
          ),
          SizedBox(
            height: 15,
          ),
          Text('Hey there!',style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.black),),
          SizedBox(height: 5,),
          Text("Log in to find your next look with ThreadSwap!", style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: 15,),
        ],
      ),
    );
  }
}
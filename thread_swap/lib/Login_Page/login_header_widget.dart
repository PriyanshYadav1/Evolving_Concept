import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/images/transparent_google.webp'),
        Text('tLoginTitle', style: Theme.of(context).textTheme.displayLarge),
        Text('tLoginSubTitle', style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
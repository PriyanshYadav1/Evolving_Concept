import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("OR"),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Image(image: AssetImage("assets/images/transparent_google.webp"), width: 20.0),
            onPressed: () {},
            label: const Text("SignInWithGoogle"),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {},
          child: Text.rich(
            TextSpan(
                text: "Don't have an account",
                style: Theme.of(context).textTheme.bodyLarge,
                children: const [
                  TextSpan(text: 'Signup', style: TextStyle(color: Colors.blue))
                ]),
          ),
        ),
      ],
    );
  }
}
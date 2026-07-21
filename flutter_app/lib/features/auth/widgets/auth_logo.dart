import 'package:flutter/material.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 30),
      child: Image.asset(
        'assets/images/logo.png',
        width: 300,
        fit: BoxFit.contain,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:qbite/screens/auth/register.dart';
import 'package:qbite/screens/auth/signin.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SiginIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}

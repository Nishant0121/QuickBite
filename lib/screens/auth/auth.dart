import 'package:flutter/material.dart';
import 'package:quick_bite/screens/auth/register.dart';
import 'package:quick_bite/screens/auth/resister.rest.dart';
import 'package:quick_bite/screens/auth/signin.dart';
import 'package:quick_bite/screens/auth/signin.rest.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  String showSignIn = "user-sign-in";
  void toggleView(String view) {
    setState(() => showSignIn = view);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn == "user-sign-in") {
      return SiginIn(toggleView: toggleView);
    } else if (showSignIn == "user-register") {
      return Register(toggleView: toggleView);
    } else if (showSignIn == "restaurant-sign-in") {
      return SiginInRest(toggleView: toggleView);
    } else {
      return RegisterRest(toggleView: toggleView);
    }
  }
}

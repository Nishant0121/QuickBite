import 'package:flutter/material.dart';
import 'package:qbite/services/auth.dart';

class SiginIn extends StatefulWidget {
  final Function toggleView;

  const SiginIn({required this.toggleView, super.key});

  @override
  State<SiginIn> createState() => _SiginInState();
}

class _SiginInState extends State<SiginIn> {
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 169, 225, 255),
      appBar: AppBar(
        title: const Text("Sign In"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 30),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: const Color.fromARGB(255, 119, 82, 158),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) => setState(() => email = value),
                decoration: const InputDecoration(
                  hintText: 'Email',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) => setState(() => password = value),
                decoration: const InputDecoration(
                  hintText: 'Password',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 119, 82, 158),
                ),
                onPressed: () {
                  _auth.signInWithEmailAndPassword(email, password);
                },
                child: const Text('Sign In',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 119, 82, 158),
                ),
                onPressed: () {
                  _auth.signInAnonymously();
                },
                child: const Text('Sign In Alternative',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              const SizedBox(height: 20),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
                onPressed: () {
                  widget.toggleView();
                },
                child: const Text("Don't have an account? Register here!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quick_bite/services/auth.dart';

class RegisterRest extends StatefulWidget {
  final Function toggleView;

  const RegisterRest({required this.toggleView, super.key});

  @override
  State<RegisterRest> createState() => _RegisterRestState();
}

class _RegisterRestState extends State<RegisterRest> {
  final AuthService _auth = AuthService();

  String email = "";
  String password = "";
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 169, 225, 255),
      appBar: AppBar(
        title: const Text("Restaurant Register"),
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
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                          onPressed: () {
                            widget.toggleView("restaurant-sign-in");
                          },
                          child: const Text("As Restaurant")),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                          onPressed: () {
                            widget.toggleView("restaurant-sign-in");
                          },
                          child: const Text("As User")),
                    ),
                  ]),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) => setState(() => name = value),
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
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
                  _auth.registerRestaurantWithEmailAndPassword(
                      email, password, name);
                },
                child: const Text('RegisterRest',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
                onPressed: () {
                  widget.toggleView("restaurant-sign-in");
                },
                child: const Text("Already have an account? Sign In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

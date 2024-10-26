import 'package:flutter/material.dart';

class Addfood extends StatefulWidget {
  const Addfood({super.key});

  @override
  State<Addfood> createState() => _AddfoodState();
}

class _AddfoodState extends State<Addfood> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Add food"),
      ),
    );
  }
}

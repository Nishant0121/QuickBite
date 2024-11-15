import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_bite/model/user.dart';
import 'package:quick_bite/screens/auth/auth.dart';
import 'package:quick_bite/screens/main.dart';
import 'package:quick_bite/services/auth.dart';


class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    final AuthService _auth = AuthService();

    String screen = "home";

    // Check if user is logged in
    if (user == null) {
      return const Authenticate();
    }

    return FutureBuilder<Map<String, dynamic>?>(
      future: _auth.getUserByUID(user?.uid ?? ""),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for data
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("User not found"));
        } else {
          // Pass fetched userData to the Home widget
          return MainPage(userData: snapshot.data!);
          // return Home(userData: snapshot.data!);
        }
      },
    );
  }
}

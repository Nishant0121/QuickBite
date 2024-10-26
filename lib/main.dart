import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:qbite/model/user.dart';
import 'package:qbite/screens/wrapper.dart';
import 'package:qbite/services/auth.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Ensure that Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      initialData: null, // or some other initial value
      value: AuthService().user,
      child: const MaterialApp(
        title: 'Flutter Demo',
        home: Wrapper(),
      ),
    );
  }
}

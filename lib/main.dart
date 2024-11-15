import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:quick_bite/components/cart.dart';
import 'package:quick_bite/model/food.dart';
import 'package:quick_bite/model/user.dart';
import 'package:quick_bite/screens/fooddetails/fooddetails.dart';
import 'package:quick_bite/screens/wrapper.dart';
import 'package:quick_bite/services/auth.dart';
import 'firebase_options.dart';
// import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize GetStorage
  // await GetStorage.init();

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        routes: {
          "/foodDetails": (context) => FoodDetailScreen(
              food: ModalRoute.of(context)!.settings.arguments as Food),
          "/cart": (context) => const UserCart(),
        },
        title: 'Quick Bite',
        home: const Wrapper(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quicklogin/utils/firebase_options.dart';
import 'package:quicklogin/screens/onboarding_screen.dart';
import 'package:quicklogin/utils/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  bool loggedIn = await LocalStorageService.isUserLoggedIn();
  runApp(MainScreen(loggedIn: loggedIn));
}


class MainScreen extends StatelessWidget {
  bool loggedIn;
  MainScreen({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(loggedin: loggedIn)
    );
  }
}